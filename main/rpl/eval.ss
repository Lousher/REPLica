(library (rpl eval)
  (export eval render)
  (import (vm bundle)
          (raylib ffi)
          (raylib constant)
          (only (chezscheme csv7) record-field-mutator record-field-accessor)
          (except (chezscheme) eval)
          (rename (chezscheme) (eval c:eval)))

  ;; --- 1. 基础配置与常量 ---
  (define *WIDTH* 1920.0)
  (define *HEIGHT* 1080.0)

  ; mutex for async loading
  (define *env-mutex* (make-mutex))

  (define list->c-int-array
    (lambda (lst)
      (let* ([len (length lst)]
	     [bv (make-bytevector (* len 4))])
	(let loop ([i 0] [remaining lst])
	  (if (null? remaining)
	      bv
	      (begin
		(bytevector-u32-set! bv (* i 4) (car remaining) (endianness little))
		(loop (+ i 1) (cdr remaining))))))))
  
  (define (extract-script-codepoints script-ast)
    (let ([char-hash (make-hashtable equal-hash char=?)])
      (define (traverse node)
	(cond
	 [(pair? node)
          (if (eq? (car node) 'text)
              (string-for-each (lambda (c) (hashtable-set! char-hash c #t)) (cadr node))
              (begin (traverse (car node)) (traverse (cdr node))))]
	 [(vector? node)
          (vector-for-each traverse node)]))
      ;; 载入基础 ASCII (32-126)
      (let loop ([i 32])
	(when (< i 127)
          (hashtable-set! char-hash (integer->char i) #t)
          (loop (+ i 1))))
      (traverse script-ast)
      ;; 返回升序排列的 Unicode CodePoint 整数列表
      (list-sort < (map char->integer (vector->list (hashtable-keys char-hash))))))

  ;; --- 2. 核心数据结构 (Records) ---
  (define-record-type branch-command (fields id cases))
  (define-record-type render-command
    (fields (mutable type) (mutable id) (mutable x) (mutable y) (mutable w) (mutable h)
            (mutable ox) (mutable oy) (mutable scale) (mutable rotation) (mutable alpha) (mutable color)))
  (define-record-type text-command
    (fields (mutable font) (mutable text) (mutable x) (mutable y)
	    (mutable w) (mutable h)
	    (mutable size) (mutable spacing) (mutable color)
	    (mutable rotation) (mutable alpha) (mutable ox) (mutable oy)))

  (define render-context-fields '(x y ox oy ax ay scale rotation alpha color font size spacing))
  (define render-context (make-record-type "render-context" render-context-fields))
  (define make-render-context (record-constructor render-context))
  (define render-context-fields-accessor (lambda (rc fs) (map (lambda (f) ((record-field-accessor render-context f) rc)) fs)))
  (define render-context-fields-mutator (lambda (rc fs vs) (for-each (lambda (f v) ((record-field-mutator render-context f) rc v)) fs vs)))

  ;; --- 3. 空间逻辑与辅助函数 ---
  (define (get-logical-spatial-info ctx w h)
    (let ([vals (render-context-fields-accessor ctx '(x y scale ax ay ox oy))])
      (apply (lambda (x y s ax ay ox oy)
               (let ([abs-x (+ x (* *WIDTH* ax))]
                     [abs-y (+ y (* *HEIGHT* ay))])
                 ;; 仅仅传递原图尺寸和当前缩放率 s
                 (list abs-x abs-y w h ox oy s)))
             vals)))

  (define call-with-render-context-mutated
    (lambda (rc mus proc)
      (let ([fs (map car mus)] [mutators-f (map cdr mus)])
        (let* ([vals (render-context-fields-accessor rc fs)])
          (render-context-fields-mutator rc fs (map (lambda (m v) (m v)) mutators-f vals))
          (proc rc)
          (render-context-fields-mutator rc fs vals)))))

  (define load-and-cache!
    (lambda (id env)
      (let loop ()
	(let ([entry (with-mutex *env-mutex* (hashtable-ref env id #f))])
	  (if entry
	      (let ([type (vector-ref entry 0)]
		    [path (vector-ref entry 1)]
		    [status (vector-ref entry 2)]
		    [payload (vector-ref entry 3)]
		    [cond-var (vector-ref entry 4)])
		(case status
		  [(ready) payload]
		  [(loading)
		   (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*))
		   (loop)]
		  [(image)
		   (let ([tex (LoadTextureFromImage payload)])
		     (UnloadImage payload)
		     (with-mutex *env-mutex*
		       (vector-set! entry 2 'ready)
		       (vector-set! entry 3 tex))
		     tex)]
		  [(error) #f]
		  [else #f]))
		#f)))))

  (define (load-font-and-cache! id env)
    (let loop ()
      (let ([entry (with-mutex *env-mutex* (hashtable-ref env id #f))])
        (if entry
            (let ([type (vector-ref entry 0)]
                  [path (vector-ref entry 1)]
                  [status (vector-ref entry 2)]
                  [payload (vector-ref entry 3)]
                  [cond-var (vector-ref entry 4)])
              (case status
                [(ready) payload]
                [(loading)
                 (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*))
                 (loop)]
                [(font-data-ready)
		 (let* ([ext (car payload)]
			[data (cadr payload)]
			[len (caddr payload)]
			[cp-info (hashtable-ref env '*codepoints* '(#f . 0))]
			[cp-ptr (car cp-info)]
			[cp-cnt (cdr cp-info)]
			[font (LoadFontFromMemory ext data len 64 cp-ptr cp-cnt)])
                   (with-mutex *env-mutex*
                     (vector-set! entry 2 'ready)
                     (vector-set! entry 3 font))
                   font)]
                [(error) #f]
                [else #f]))
            #f))))

  (define substitute
    (lambda (tree bindings)
      (cond [(null? tree) '()]
            [(symbol? tree) (let ([b (assq tree bindings)]) (if b (cdr b) tree))]
            [(pair? tree) (cons (substitute (car tree) bindings) (substitute (cdr tree) bindings))]
            [else tree])))

  ;; --- 4. 编译器逻辑 (Eval & Compile) ---
  (define compile-predicate
    (lambda (exp ctx)
      (if (eqv? 'else exp) (lambda (mx my) #t)
          (case (car exp)
            [(hovered?)
             (let* ([w (cadr exp)] [h (caddr exp)]
                    [info (get-logical-spatial-info ctx w h)]
                    [hx (car info)] [hy (cadr info)] 
                    [raw-w (caddr info)] [raw-h (cadddr info)]
                    [s (list-ref info 6)]
                    ;; 在编译期算死真实的物理判定尺寸
                    [hw (* raw-w s)] [hh (* raw-h s)])
               (lambda (mx my)
                 (and (>= mx hx) (<= mx (+ hx hw))
                      (>= my hy) (<= my (+ hy hh)))))]
            [else (lambda (mx my) #t)]))))

  (define *current-bundles* #f)
  (define *command-list* '())
  (define *uid* 0)
  (define gen-uid (lambda () (set! *uid* (+ 1 *uid*)) *uid*))
  (define *primitives* (make-hashtable symbol-hash symbol=?))

  (define eval
    (lambda (exp env ctx)
      (let ([handler (hashtable-ref *primitives* (car exp) #f)])
        (if handler
            (handler exp env ctx)
            (let ([prefab-def (hashtable-ref env (car exp) #f)])
              (if (and prefab-def (eq? (car prefab-def) 'prefab))
                  (eval (substitute (caddr prefab-def) (map cons (cadr prefab-def) (cdr exp))) env ctx)
                  (error 'eval "Unknown primitive or prefab" (car exp))))))))

  (define (get-tint color-list alpha)
    (make-Color (car color-list) 
		(cadr color-list) 
		(caddr color-list)
		(inexact->exact (round (* (cadddr color-list) alpha)))))
  ;; --- 5. 渲染后端 (Consume) ---
  (define consume
    (lambda (cmds mx my scale ox oy)
      (for-each
       (lambda (cmd)
         (cond
          [(render-command? cmd)
           (let* ([tex (render-command-id cmd)]
                  [final-s (* (render-command-scale cmd) scale)]
                  [final-x (+ (* (render-command-x cmd) scale) ox)]
                  [final-y (+ (* (render-command-y cmd) scale) oy)]
                  ;; 只有渲染到屏幕的 DestRect 会缩小
                  [final-w (* (render-command-w cmd) final-s)]
                  [final-h (* (render-command-h cmd) final-s)]
                  [origin (make-vector2 (* (render-command-ox cmd) final-s) 
                                        (* (render-command-oy cmd) final-s))]
                  [dest-rect (make-rectangle final-x final-y final-w final-h)]
                  ;; SourceRect 永远保持原图大小裁剪！
                  [source-rect (make-rectangle 0.0 0.0 (render-command-w cmd) (render-command-h cmd))]
		  [tint (get-tint (render-command-color cmd) (render-command-alpha cmd))])
             (DrawTexturePro tex source-rect dest-rect origin (render-command-rotation cmd) tint))]
	  [(text-command? cmd)
	    (let* ([final-s scale] ; 物理缩放
		   [final-x (+ (* (text-command-x cmd) scale) ox)]
		   [final-y (+ (* (text-command-y cmd) scale) oy)]
		   ;; 文字的 Size 和 Spacing 自动受外层 Scale 控制
		   [final-size (* (text-command-size cmd) final-s)]
		   [final-space (* (text-command-spacing cmd) final-s)]
		   [origin (make-vector2 (* (text-command-ox cmd) final-s) (* (text-command-oy cmd) final-s))]
		   [pos (make-vector2 final-x final-y)]
		   [tint (get-tint (text-command-color cmd) (text-command-alpha cmd))])
	      ;; 【新增】：使用完全对等的 DrawTextPro
	      (DrawTextPro (text-command-font cmd) (text-command-text cmd) pos origin 
			   (text-command-rotation cmd) final-size final-space tint))]
          [(branch-command? cmd)
           (let loop ([cases (branch-command-cases cmd)])
             (unless (null? cases)
               (let* ([ca (car cases)] [pred (car ca)] [sub-cmds (cdr ca)])
                 (if (pred mx my)
                     (consume sub-cmds mx my scale ox oy)
                     (loop (cdr cases))))))]))
       cmds)))

  (define render
    (lambda (scripts)
      (InitWindow 1280 720 "RPL - Engine Perfected")
      (SetTargetFPS 60)
      (let* ([all-chars (extract-script-codepoints scripts)]
	     [char-count (length all-chars)]
	     [codepoints-ptr (list->c-int-array all-chars)])
	(let ([env (make-hashtable symbol-hash symbol=?)]
              [ctx (make-render-context 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 1.0 '(255 255 255 255) #f 24.0 1.0)])
	  (hashtable-set! env '*codepoints* (cons codepoints-ptr char-count))
          (set! *command-list* '())
          (for-each (lambda (exp) (eval exp env ctx)) scripts)
          (let loop ()
          (unless (WindowShouldClose)
            (let* ([sw (GetScreenWidth)] [sh (GetScreenHeight)]
                   [s (min (/ sw *WIDTH*) (/ sh *HEIGHT*))]
                   [ox (/ (- sw (* *WIDTH* s)) 2.0)]
                   [oy (/ (- sh (* *HEIGHT* s)) 2.0)]
                   [lmx (/ (- (GetMouseX) ox) s)]
                   [lmy (/ (- (GetMouseY) oy) s)])
              (BeginDrawing)
              (ClearBackground BLACK)
              (consume (reverse *command-list*) lmx lmy s ox oy)
              (EndDrawing)
              (loop))))))
      (when *current-bundles* (unmount *current-bundles*))
      (CloseWindow)))

  ;; --- 6. 指令注册 (Expressions) ---
  (define (define-primitive name proc) (hashtable-set! *primitives* name proc))

  (define-primitive 'bundle (lambda (exp env ctx) (set! *current-bundles* (mount (cadr exp)))))
  (define-primitive
    'assets
    (lambda (exp env ctx)
      (for-each
       (lambda (def)
	 (let ([type (car def)]
	       [id (cadr def)]
	       [path (caddr def)]
	       [cond-var (make-condition)])
	   (with-mutex *env-mutex*
	     (hashtable-set! env id (vector type path 'loading #f cond-var)))
	     (fork-thread
	      (lambda ()
		(let-values ([(ext data len) (ref *current-bundles* path)])
		  (TraceLog LOG_INFO (format "ASSETS: Forked Thread to Load Resourse ~a" path))
		  (case type
		    [(texture)
		     (if data
			 (let ([img (LoadImageFromMemory ext data len)])
			   (with-mutex *env-mutex*
			     (let ([entry (hashtable-ref env id #f)])
			       (vector-set! entry 2 'image)
			       (vector-set! entry 3 img)
			       (condition-broadcast cond-var))))
			 (begin
			   (TraceLog LOG_ERROR (format "ASSETS: Resource ~a Not Found" path))
			   (with-mutex *env-mutex*
			     (let ([entry (hashtable-ref env id #f)])
			       (vector-set! entry 2 'error)
			       (condition-broadcast cond-var)))))]
		    [(font)
		     (let-values ([(ext data len) (ref *current-bundles* path)])
		       (if data 
			   (with-mutex *env-mutex*
			     (let ([entry (hashtable-ref env id #f)])
			       (vector-set! entry 2 'font-data-ready)
			       (vector-set! entry 3 (list ext data len))
			       (condition-broadcast cond-var)))
			   (begin
			     (TraceLog LOG_ERROR (format "ASSETS: Font File ~a Not Found" path))
			     (with-mutex *env-mutex*
			       (let ([entry (hashtable-ref env id #f)])
				 (vector-set! entry 2 'error)
				 (condition-broadcast cond-var))))))]))))))
       (cdr exp))))
  (define-primitive 'prefab (lambda (exp env ctx) (hashtable-set! env (cadr exp) (list 'prefab (caddr exp) (cadddr exp)))))
  (define-primitive 'parallel (lambda (exp env ctx) (for-each (lambda (sub) (eval sub env ctx)) (cdr exp))))
  
  (define-primitive 'branch 
    (lambda (exp env ctx)
      (let ([saved *command-list*])
        (let ([compiled (map (lambda (b)
                               (let ([pred-fn (compile-predicate (car b) ctx)])
                                 (set! *command-list* '())
                                 (eval (cadr b) env ctx)
                                 (cons pred-fn (reverse *command-list*))))
                             (cdr exp))])
          (set! *command-list* saved)
          (set! *command-list* (cons (make-branch-command (gen-uid) compiled) *command-list*))))))


  (define-primitive 'at 
    (lambda (exp env ctx)
      (let ([s ((record-field-accessor render-context 'scale) ctx)])
	(call-with-render-context-mutated
	 ctx 
	 `((x . ,(lambda (v) (+ v (* s (cadr exp))))) 
	   (y . ,(lambda (v) (+ v (* s (caddr exp))))))
	 (lambda (c) (eval (cadddr exp) env c))))))
  
  (define-primitive 'scale (lambda (exp env ctx) (call-with-render-context-mutated ctx `((scale . ,(lambda (v) (* v (cadr exp))))) (lambda (c) (eval (caddr exp) env c)))))
  (define-primitive 'alpha (lambda (exp env ctx) (call-with-render-context-mutated ctx `((alpha . ,(lambda (v) (* v (cadr exp))))) (lambda (c) (eval (caddr exp) env c)))))
  (define-primitive 'anchor (lambda (exp env ctx) (call-with-render-context-mutated ctx `((ax . ,(lambda (v) (cadr exp))) (ay . ,(lambda (v) (caddr exp)))) (lambda (c) (eval (cadddr exp) env c)))))
  (define-primitive 'origin (lambda (exp env ctx) (call-with-render-context-mutated ctx `((ox . ,(lambda (v) (cadr exp))) (oy . ,(lambda (v) (caddr exp)))) (lambda (c) (eval (cadddr exp) env c)))))
  (define-primitive 'rotate (lambda (exp env ctx) (call-with-render-context-mutated ctx `((rotation . ,(lambda (v) (+ v (cadr exp))))) (lambda (c) (eval (caddr exp) env c)))))

  (define-primitive 'show
    (lambda (exp env ctx)
      (let* ([sym (cadr exp)] [cached (load-and-cache! sym env)])
        (when cached
          (let* ([info (get-logical-spatial-info ctx (Texture-width cached) (Texture-height cached))]
                 [rot ((record-field-accessor render-context 'rotation) ctx)]
                 [alpha ((record-field-accessor render-context 'alpha) ctx)]
		 [col ((record-field-accessor render-context 'color) ctx)])
            (set! *command-list*
                  (cons (apply (lambda (ax ay aw ah aox aoy as)
                                 (make-render-command 'TEXTURE cached ax ay aw ah aox aoy as rot alpha col))
                               info)
                        *command-list*)))))))

 (define-primitive 'text
  (lambda (exp env ctx)
    (let* ([str (cadr exp)]
           [fid ((record-field-accessor render-context 'font) ctx)]
           [fsize ((record-field-accessor render-context 'size) ctx)]
           [fspace ((record-field-accessor render-context 'spacing) ctx)]
           [font-asset (and fid (load-font-and-cache! fid env))]

           )
      (when font-asset
        ;; 使用 Raylib 测量逻辑宽高等比例
        (let* ([vec2-size (MeasureTextEx font-asset str fsize fspace)]
               [raw-w (Vector2-x vec2-size)] ; 假设你的 FFI 有 Vector2-x 访问器
               [raw-h (Vector2-y vec2-size)]
               ;; 文字现在完美支持 at, origin, anchor 等一切空间算子！
               [info (get-logical-spatial-info ctx raw-w raw-h)]
               [rot ((record-field-accessor render-context 'rotation) ctx)]
               [alpha ((record-field-accessor render-context 'alpha) ctx)]
               [col ((record-field-accessor render-context 'color) ctx)])
          (set! *command-list*
                (cons (apply (lambda (ax ay aw ah aox aoy as)
                               (make-text-command font-asset str ax ay raw-w raw-h fsize fspace col rot alpha aox aoy))
                             info)
                      *command-list*)))))))

  (define-primitive 'color 
    (lambda (exp env ctx)
      (call-with-render-context-mutated
       ctx 
       `((color . ,(lambda (v) (list-head (cdr exp) 4)))) ;; (color 255 0 0 255) -> 存入 '(255 0 0 255)
       (lambda (c) (eval (car (reverse exp)) env c)))))

  (define-primitive 'font 
    (lambda (exp env ctx)
      (call-with-render-context-mutated
       ctx
       `((font . ,(lambda (v) (cadr exp))))
       (lambda (c) (eval (caddr exp) env c)))))

  (define-primitive 'size 
    (lambda (exp env ctx)
      (call-with-render-context-mutated
       ctx
       `((size . ,(lambda (v) (cadr exp))))
       (lambda (c) (eval (caddr exp) env c)))))

  (define-primitive 'spacing 
    (lambda (exp env ctx)
      (call-with-render-context-mutated
       ctx
       `((spacing . ,(lambda (v) (cadr exp))))
       (lambda (c) (eval (caddr exp) env c)))))

  
  )
