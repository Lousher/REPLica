(library (rpl eval)
  (export eval render)
  (import (tool bundle)
          (raylib ffi)
          (raylib constant)
          (only (chezscheme csv7) record-field-mutator record-field-accessor)
          (except (chezscheme) eval)
          (rename (chezscheme) (eval c:eval)))

  ;; --- 1. 基础配置与全局状态 ---
  (define *WIDTH* 1920.0)
  (define *HEIGHT* 1080.0)
  (define *env-mutex* (make-mutex))
  (define *scene-root* #f)
  (define *current-parent* #f)
  (define *current-bundles* '())
  (define *sdf-shader*)

  ;; VM state saver
  (define *current-scripts* #f)
  (define *pc* 0)
  (define *call-stack* '())
  (define *jump-signal* #f)

  ;; 多个bundle搜索
  (define (find-resource-in-all-bundles path)
    ;; 按列表顺序搜寻，因为新挂载的包在列表头(cons)，所以实现了“最新覆盖” 
    (let loop ([bundles *current-bundles*])
      (if (null? bundles)
          (values #f #f #f) ;; 所有包都找遍了，未命中
          (let-values ([(ext data len) (ref (car bundles) path)]) ;; 调用 bundle.ss 的 ref [cite: 12]
            (if data
		(values ext data len) ;; 命中资源，立即返回
		(loop (cdr bundles)))))))

  (define (load-rpl-file path)
  ;; 使用循环读取文件中所有的 S-表达式，直到文件结束
    (with-input-from-file path
      (lambda ()
	(let loop ([acc '()])
          (let ([exp (read)])
            (if (eof-object? exp)
		(list->vector (reverse acc)) ;; 到达文件末尾，反转列表并转为向量
		(loop (cons exp acc)))))))) ;; 继续读取下一个表达式

  (define (clear-scene!)
    ;; 跳转新剧本时清空舞台，防止旧章节残留 
    (when *scene-root*
      (scene-node-children-set! *scene-root* '())
      (set! *current-parent* *scene-root*)))
  
  ;; --- 2. 数据结构定义 (Records) ---
  (define-record-type scene-node
    (fields (mutable type)       ; 'root, 'texture, 'text, 'group, 'branch, 'audio
            (mutable id)         ; 资源 ID
            (mutable payload)    ; 物理对象 (Texture/Font/Sound)
            (mutable x) (mutable y)
            (mutable ax) (mutable ay) ; Anchor (0.0-1.0)
            (mutable ox) (mutable oy) ; Origin (0.0-1.0)
            (mutable scale) (mutable rotation)
            (mutable alpha) (mutable color)
            (mutable children)   ; 子节点列表
            (mutable visible?)   ; 是否可见
            (mutable data)       ; 扩展数据 (Text 内容或 Branch 列表)
            (mutable status)))   ; 生命周期状态 ('ready, 'expired)

  (define render-context-fields '(color font size spacing typeface))
  (define render-context (make-record-type "render-context" render-context-fields))
  (define make-render-context (record-constructor render-context))
  (define render-context-fields-accessor (lambda (rc fs) (map (lambda (f) ((record-field-accessor render-context f) rc)) fs)))
  (define render-context-fields-mutator (lambda (rc fs vs) (for-each (lambda (f v) ((record-field-mutator render-context f) rc v)) fs vs)))

  (define call-with-render-context-mutated
    (lambda (rc mus proc)
      (let ([fs (map car mus)] [mutators-f (map cdr mus)])
        (let* ([vals (render-context-fields-accessor rc fs)])
          (render-context-fields-mutator rc fs (map (lambda (m v) (m v)) mutators-f vals))
          (proc rc)
          (render-context-fields-mutator rc fs vals)))))

  ;; --- 3. 辅助函数 (Utils) ---
  (define (make-default-node type id payload data)
    (make-scene-node type id payload 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 1.0 '(255 255 255 255) '() #t data 'ready))

  (define (get-tint color-list alpha)
    (make-Color (car color-list) (cadr color-list) (caddr color-list) 
                (inexact->exact (round (* (cadddr color-list) alpha)))))

  (define (reset-audio-status node)
    (when (eq? (scene-node-type node) 'audio) (scene-node-status-set! node 'ready))
    (for-each reset-audio-status (scene-node-children node)))

  ;; --- 4. 资源加载函数 ---
  (define load-and-cache!
    (lambda (id env)
      (let loop ()
        (let ([entry (with-mutex *env-mutex* (hashtable-ref env id #f))])
          (if entry
              (let ([status (vector-ref entry 2)] [payload (vector-ref entry 3)] [cond-var (vector-ref entry 4)])
                (case status
                  [(ready) payload]
                  [(loading) (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*)) (loop)]
                  [(image) (let ([tex (LoadTextureFromImage payload)]) (UnloadImage payload)
				(with-mutex *env-mutex* (vector-set! entry 2 'ready) (vector-set! entry 3 tex)) tex)]
                  [else #f]))
              #f)))))

  (define (load-sound-and-cache! id env)
    (let loop ()
      (let ([entry (with-mutex *env-mutex* (hashtable-ref env id #f))])
        (if entry
            (let ([status (vector-ref entry 2)] [payload (vector-ref entry 3)] [cond-var (vector-ref entry 4)])
              (case status
                [(ready) payload]
                [(loading) (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*)) (loop)]
                [(wav-data-ready) (let ([snd (LoadSoundFromWave payload)]) (UnloadWave payload)
                                       (with-mutex *env-mutex* (vector-set! entry 2 'ready) (vector-set! entry 3 snd)) snd)]
                [else #f]))
            #f))))

  (define (load-font-and-cache! id env)
    (let loop ()
      (let ([entry (with-mutex *env-mutex* (hashtable-ref env id #f))])
        (if entry
            (let ([status (vector-ref entry 2)] [payload (vector-ref entry 3)] [cond-var (vector-ref entry 4)])
              (case status
                [(ready) payload]
                [(loading) (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*)) (loop)]
                [(font-data-ready) (let* ([ext (car payload)] [data (cadr payload)] [len (caddr payload)]
                                          [cp-info (hashtable-ref env '*codepoints* '(#f . 0))]
                                          [font (LoadFontFromMemory ext data len 128 (car cp-info) (cdr cp-info))])
                                     (with-mutex *env-mutex* (vector-set! entry 2 'ready) (vector-set! entry 3 font)) font)]
                [else #f]))
            #f))))

  (define (parse-bin-metadata bv len)
    (let ([map (make-hashtable (lambda (x) x) =)]
          [count (bytevector-s32-ref bv 0 (endianness little))]) ;; 读取头部的总字数
      (let loop ([i 0] [offset 4]) ;; 从第 4 字节开始读取每个字形的数据
        (if (< i count)
            (let ([cp  (bytevector-s32-ref bv offset (endianness little))]
                  [rx  (bytevector-ieee-single-ref bv (+ offset 4) (endianness little))]
                  [ry  (bytevector-ieee-single-ref bv (+ offset 8) (endianness little))]
                  [rw  (bytevector-ieee-single-ref bv (+ offset 12) (endianness little))]
                  [rh  (bytevector-ieee-single-ref bv (+ offset 16) (endianness little))]
                  [ox  (bytevector-s32-ref bv (+ offset 20) (endianness little))]
                  [oy  (bytevector-s32-ref bv (+ offset 24) (endianness little))]
                  [adv (bytevector-s32-ref bv (+ offset 28) (endianness little))])
              (hashtable-set! map cp 
                (vector (make-rectangle rx ry rw rh) ox oy adv))
              (loop (+ i 1) (+ offset 32)))
            map))))
  
  (define (load-typeface-and-cache! id env)
    (let loop ()
      (let ([entry (with-mutex *env-mutex* (hashtable-ref env id #f))])
        (if entry
            (let ([status (vector-ref entry 2)] 
                  [payload (vector-ref entry 3)] 
                  [cond-var (vector-ref entry 4)])
              (case status
                [(ready) payload]
                [(loading) (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*)) (loop)]
                [(typeface-data-ready)
                 ;; 【核心修复】主线程加锁抢占，确保 UnloadImage 只执行一次 [cite: 25-26]
                 (let ([can-proceed? (with-mutex *env-mutex*
                                       (if (eq? (vector-ref entry 2) 'typeface-data-ready)
                                           (begin (vector-set! entry 2 'converting) #t)
                                           #f))])
                   (if can-proceed?
                       (let* ([img (car payload)] [glyph-map (cdr payload)]
                              [tex (LoadTextureFromImage img)])
                         (SetTextureFilter tex 1)
                         (UnloadImage img) ;; 安全释放大图内存 [cite: 27]
                         (with-mutex *env-mutex*
                           (vector-set! entry 2 'ready)
                           (vector-set! entry 3 (cons tex glyph-map))
                           (condition-broadcast cond-var))
                         (cons tex glyph-map))
                       (loop)))]
                [(converting) (with-mutex *env-mutex* (condition-wait cond-var *env-mutex*)) (loop)]
                [else #f]))
            #f))))

  ;; --- 5. 渲染后端 (Recursive Scene Tree Processor) ---
  (define (consume-tree node px py ps pa mx my screen-scale screen-ox screen-oy)
    (when (scene-node-visible? node)
      (let* ([cur-s (* ps (scene-node-scale node))]
             [cur-x (+ px (* (scene-node-x node) ps) (* *WIDTH* (scene-node-ax node) ps))]
             [cur-y (+ py (* (scene-node-y node) ps) (* *HEIGHT* (scene-node-ay node) ps))]
             [cur-a (* pa (scene-node-alpha node))]
             [tint (get-tint (scene-node-color node) cur-a)]
	     )
        (case (scene-node-type node)
          [(texture) (let* ([tex (scene-node-payload node)] [w (Texture-width tex)] [h (Texture-height tex)]
                            [render-x (+ (* cur-x screen-scale) screen-ox)] [render-y (+ (* cur-y screen-scale) screen-oy)]
                            [dest (make-rectangle render-x render-y (* w cur-s screen-scale) (* h cur-s screen-scale))]
                            [src (make-rectangle 0.0 0.0 w h)]
                            [origin (make-vector2 (* (scene-node-ox node) w cur-s screen-scale) (* (scene-node-oy node) h cur-s screen-scale))])
                       (DrawTexturePro tex src dest origin (scene-node-rotation node) tint))]
          [(text) (let ([font (scene-node-payload node)] [str (scene-node-data node)])
                    (DrawTextEx font str (make-vector2 (+ (* cur-x screen-scale) screen-ox) (+ (* cur-y screen-scale) screen-oy))
                                (* 24.0 cur-s screen-scale) (* 1.0 screen-scale) tint))]
          [(audio) (when (eq? (scene-node-status node) 'ready) (PlaySound (scene-node-payload node)) (scene-node-status-set! node 'expired))]
          [(interact)
	   (let* ([node-data (scene-node-data node)]
		  [scope (car node-data)]
		  [cases (cadr node-data)]
		  ;; 1. 预计算环境状态
		  [is-global? (eq? (car scope) 'global)]
		  [is-hover? (if is-global? #t
				 (let ([w (* (car scope) cur-s)] [h (* (cadr scope) cur-s)])
				   (and (>= mx cur-x) (<= mx (+ cur-x w))
					(>= my cur-y) (<= my (+ cur-y h)))))]
		  [is-click?
		   (let ([w (* (car scope) cur-s)] [h (* (cadr scope) cur-s)])
		     (and (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
		      (>= mx cur-x) (<= mx (+ cur-x w))
		      (>= my cur-y) (<= my (+ cur-y h))))]
		  [any-visual-state-hit? #f])
	     ;; 2. 并行扫描所有分支 (不再是匹配一个就跳出)
	     (for-each 
	      (lambda (ca)
		(let* ([cond-list (car ca)]
		       [sub-node (cdr ca)]
		       ;; 【核心】AND 逻辑：检查列表中所有条件是否全部成立
		       [all-matched? (let check ([cs cond-list])
				       (if (null? cs) #t
					   (let ([c (car cs)])
					     (and (case c
						    [(click) is-click?]
						    [(hover) is-hover?]
						    [(else)  (not any-visual-state-hit?)]
						    [else    #f])
						  (check (cdr cs))))))])
		  (when all-matched?
		    ;; 如果条件包含点击，则重置音频状态使其能再次播放
		    (when (memq 'click cond-list) (reset-audio-status sub-node))
		    
		    ;; 渲染该分支的子树 
		    (consume-tree sub-node cur-x cur-y cur-s cur-a mx my screen-scale screen-ox screen-oy)
		    
		    ;; 如果该分支包含视觉状态(hover)，标记已命中，防止后续 else 触发
		    (when (and (memq 'hover cond-list) (not (memq 'click cond-list)))
		      (set! any-visual-state-hit? #t)))))
	      cases))]
	  [(label)
	   (let* ([font-bundle (scene-node-payload node)]
		  [atlas-tex (car font-bundle)]
		  [glyph-map (cdr font-bundle)]
		  [str (scene-node-data node)]
		  [base-size 128.0]
		  [targeg-size 24.0]
		  [s (* (/ targeg-size base-size) cur-s screen-scale)])
	     (BeginShaderMode *sdf-shader*)
	     (let loop ([chars (string->list str)] [cx 0.0])
	       (unless (null? chars)
		 (let* ([cp (char->integer (car chars))]
			[info (hashtable-ref glyph-map cp #f)])
		   (when info
		     (let ([src (vector-ref info 0)]
			   [ox (vector-ref info 1)]
			   [oy (vector-ref info 2)]
			   [adv (vector-ref info 3)])
		       (let ([dest (make-rectangle
				    (+ (* cur-x screen-scale) screen-ox (* (+ cx ox) s))
				    (+ (* cur-y screen-scale) screen-oy (* oy s))
				    (* (Rectangle-width src) s)
				    (* (Rectangle-height src) s))])
			 (DrawTexturePro atlas-tex src dest (make-vector2 0 0)
					 (scene-node-rotation node) tint)
			 (loop (cdr chars) (+ cx adv))))))))
	     (EndShaderMode)
	     )])
        (unless (eq? (scene-node-type node) 'branch)
          (for-each (lambda (child) (consume-tree child cur-x cur-y cur-s cur-a mx my screen-scale screen-ox screen-oy)) (reverse (scene-node-children node)))))))

  ;; --- 6. 指令分发与环境 (Eval & Setup) ---
  (define *primitives* (make-hashtable symbol-hash symbol=?))
  (define (define-primitive name proc) (hashtable-set! *primitives* name proc))

  (define (substitute tree bindings)
    (cond [(null? tree) '()] [(symbol? tree) (let ([b (assq tree bindings)]) (if b (cdr b) tree))]
          [(pair? tree) (cons (substitute (car tree) bindings) (substitute (cdr tree) bindings))]
          [else tree]))

  (define (eval exp env ctx)
    (let ([handler (hashtable-ref *primitives* (car exp) #f)])
      (if handler (handler exp env ctx)
          (let ([prefab-def (hashtable-ref env (car exp) #f)])
            (if (and prefab-def (eq? (car prefab-def) 'prefab))
                (eval (substitute (caddr prefab-def) (map cons (cadr prefab-def) (cdr exp))) env ctx)
                (error 'eval "Unknown primitive" (car exp)))))))

  (define (make-group-wrapper proc setter-fn env ctx)
    (let ([group (make-default-node 'group 'grp #f #f)] [old-parent *current-parent*])
      (setter-fn group)
      (scene-node-children-set! old-parent (cons group (scene-node-children old-parent)))
      (set! *current-parent* group) (proc) (set! *current-parent* old-parent)))

  (define (step! env ctx)
    (when (and *current-scripts* (< *pc* (vector-length *current-scripts*)))
      (let ([exp (vector-ref *current-scripts* *pc*)])
        (set! *pc* (+ *pc* 1))
        (eval exp env ctx)
        ;; 跳转信号处理：由 Primitive 发起，在此处统一执行状态切换
        (cond
          [*jump-signal* (let ([signal *jump-signal*])
             (set! *jump-signal* #f)
             (case (car signal)
               [(jump) ;; 彻底跳转：加载新文件，重置 PC，清空舞台 
                (set! *current-scripts* (load-rpl-file (cdr signal)))
                (set! *pc* 0)
                (clear-scene!)
                (step! env ctx)]
               [(call) ;; 调用子剧本：压栈当前进度，跳转新文件
                (set! *call-stack* (cons (cons *current-scripts* *pc*) *call-stack*))
                (set! *current-scripts* (load-rpl-file (cdr signal)))
                (set! *pc* 0)
                (step! env ctx)]
               [(return) ;; 返回上一级：弹栈恢复旧脚本和 PC 
                (if (null? *call-stack*) (error 'return "Call stack empty")
                    (let ([top (car *call-stack*)])
                      (set! *call-stack* (cdr *call-stack*))
                      (set! *current-scripts* (car top))
                      (set! *pc* (cdr top))
                      (step! env ctx)))]))]
          ;; 只有遇到文本时才停止自动步进，等待玩家点击 [cite: 39]
          [(not (eq? (car exp) 'text)) (step! env ctx)]))))

  ;; --- 7. 主渲染器 (Render) ---
  (define render
    (lambda (entry-path) ;; 之前是 scripts-list 
      (let* ([env (make-hashtable symbol-hash symbol=?)]
             [ctx (make-render-context '(255 255 255 255) #f 24.0 1.0 #f)])
        (InitWindow 1280 720 "RPL VM Engine")
        (InitAudioDevice)
        (SetTargetFPS 60)
        
        ;; 初始化 VM 寄存器 [cite: 40, 41]
        (set! *current-scripts* (load-rpl-file entry-path))
        (set! *pc* 0)
        (set! *scene-root* (make-default-node 'root 'root #f #f))
        (set! *current-parent* *scene-root*)
	(set! *sdf-shader* (LoadShader #f "main/sdf.fs"))

        (step! env ctx)

        (let loop () 
          (unless (WindowShouldClose)
            (let* ([sw (GetScreenWidth)] [sh (GetScreenHeight)]
                   [s (min (/ sw *WIDTH*) (/ sh *HEIGHT*))]
                   [ox (/ (- sw (* *WIDTH* s)) 2.0)] [oy (/ (- sh (* *HEIGHT* s)) 2.0)])
              (BeginDrawing)
              (ClearBackground BLACK)
              ;; 玩家点击屏幕推进到下一条指令 [cite: 39, 42]
              (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT) (step! env ctx))
              (let ([mx (/ (- (GetMouseX) ox) s)] [my (/ (- (GetMouseY) oy) s)])
                (consume-tree *scene-root* 0.0 0.0 1.0 1.0 mx my s ox oy))
              (EndDrawing)
              (loop))))
        (CloseAudioDevice)
        (CloseWindow))))

  ;; --- 8. 指令注册 (Expressions) ---
  ;; 所有 define-primitive 必须放在所有 define 之后
  (define-primitive 'bundle
    (lambda (exp env ctx)
      (let ([b (mount (cadr exp))])
	(with-mutex *env-mutex* (set! *current-bundles* (cons b *current-bundles*))))))
  
  (define-primitive 'assets
    (lambda (exp env ctx) 
      (for-each
       (lambda (def) 
         (let ([type (car def)] 
               [id (cadr def)] 
               [paths (cddr def)] ;; 识别 (type id . paths)
	       )
	   (unless (with-mutex *env-mutex* (hashtable-contains? env id))
	     (let ([cond-var (make-condition)])
           ;; 统一初始化状态为 loading，并将 paths 列表存入 payload 
               (with-mutex *env-mutex* (hashtable-set! env id (vector type paths 'loading #f cond-var)))
               (fork-thread
		(lambda ()
		  (case type
                    ;; --- 新增 Typeface 处理逻辑 ---
                    [(typeface)
                     (let ([png-path (car paths)]
			   [bin-path (cadr paths)])
                       (let-values ([(p-ext p-data p-len) (find-resource-in-all-bundles png-path)]
                                    [(b-ext b-data b-len) (find-resource-in-all-bundles bin-path)])
			 (if (and p-data b-data)
                             (let* ([img (LoadImageFromMemory p-ext p-data p-len)]
;                                    [_ (ImageFormat img 1)] ;; SDF 灰度优化 /no way because of ffi definition
                                    [glyph-map (parse-bin-metadata b-data b-len)])
                               (with-mutex *env-mutex*
				 (let ([entry (hashtable-ref env id #f)])
				   (vector-set! entry 2 'typeface-data-ready)
				   (vector-set! entry 3 (cons img glyph-map)) ;; 存入对子 [cite: 14]
				   (condition-broadcast cond-var))))
                             (with-mutex *env-mutex*
                               (vector-set! (hashtable-ref env id #f) 2 'error)
                               (condition-broadcast cond-var)))))]
                    ;; --- 标准单路径资源处理 ---
                    [(texture)
                     (let ([path (car paths)])
                       (let-values ([(ext data len) (find-resource-in-all-bundles path)])
			 (if data
                             (let ([img (LoadImageFromMemory ext data len)])
                               (with-mutex *env-mutex* (let ([entry (hashtable-ref env id #f)]) 
							 (vector-set! entry 2 'image) 
							 (vector-set! entry 3 img) 
							 (condition-broadcast cond-var))))
                             (with-mutex *env-mutex* (vector-set! (hashtable-ref env id #f) 2 'error) 
					 (condition-broadcast cond-var)))))]
                    
                    [(font)
                     (let ([path (car paths)])
                       (let-values ([(ext data len) (find-resource-in-all-bundles path)])
			 (if data
                             (with-mutex *env-mutex* (let ([entry (hashtable-ref env id #f)]) 
						       (vector-set! entry 2 'font-data-ready) 
						       (vector-set! entry 3 (list ext data len)) 
						       (condition-broadcast cond-var)))
                             (with-mutex *env-mutex* (vector-set! (hashtable-ref env id #f) 2 'error) 
					 (condition-broadcast cond-var)))))]
                    [(sound)
                     (let ([path (car paths)])
                       (let-values ([(ext data len) (find-resource-in-all-bundles path)])
			 (if data
                             (let ([wav (LoadWaveFromMemory ext data len)])
                               (with-mutex *env-mutex* (let ([entry (hashtable-ref env id #f)]) 
							 (vector-set! entry 2 'wav-data-ready) 
							 (vector-set! entry 3 wav) 
							 (condition-broadcast cond-var))))
                             (with-mutex *env-mutex* (vector-set! (hashtable-ref env id #f) 2 'error) 
					 (condition-broadcast cond-var)))))])))))))
	   (cdr exp))))

  (define-primitive 'prefab (lambda (exp env ctx) (hashtable-set! env (cadr exp) (list 'prefab (caddr exp) (cadddr exp)))))
  (define-primitive 'parallel (lambda (exp env ctx) (for-each (lambda (sub) (eval sub env ctx)) (cdr exp))))
  (define-primitive 'at (lambda (exp env ctx) (make-group-wrapper (lambda () (eval (cadddr exp) env ctx)) (lambda (g) (scene-node-x-set! g (cadr exp)) (scene-node-y-set! g (caddr exp))) env ctx)))
  (define-primitive 'scale (lambda (exp env ctx) (make-group-wrapper (lambda () (eval (caddr exp) env ctx)) (lambda (g) (scene-node-scale-set! g (cadr exp))) env ctx)))
  (define-primitive 'alpha (lambda (exp env ctx) (make-group-wrapper (lambda () (eval (caddr exp) env ctx)) (lambda (g) (scene-node-alpha-set! g (cadr exp))) env ctx)))
  (define-primitive 'rotate (lambda (exp env ctx) (make-group-wrapper (lambda () (eval (caddr exp) env ctx)) (lambda (g) (scene-node-rotation-set! g (cadr exp))) env ctx)))
  (define-primitive 'anchor (lambda (exp env ctx) (make-group-wrapper (lambda () (eval (cadddr exp) env ctx)) (lambda (g) (scene-node-ax-set! g (cadr exp)) (scene-node-ay-set! g (caddr exp))) env ctx)))
  (define-primitive 'origin (lambda (exp env ctx) (make-group-wrapper (lambda () (eval (cadddr exp) env ctx)) (lambda (g) (scene-node-ox-set! g (cadr exp)) (scene-node-oy-set! g (caddr exp))) env ctx)))

  (define-primitive 'show (lambda (exp env ctx) (let* ([id (cadr exp)] [cached (load-and-cache! id env)])
						  (when cached (scene-node-children-set! *current-parent* (cons (make-default-node 'texture id cached #f) (scene-node-children *current-parent*)))))))

  (define-primitive 'play (lambda (exp env ctx) (let* ([id (cadr exp)] [snd (load-sound-and-cache! id env)])
						  (when snd (scene-node-children-set! *current-parent* (cons (make-default-node 'audio id snd #f) (scene-node-children *current-parent*)))))))

  (define-primitive 'text (lambda (exp env ctx) (let* ([str (cadr exp)] [fid ((record-field-accessor render-context 'font) ctx)] [font (and fid (load-font-and-cache! fid env))])
						  (when font (scene-node-children-set! *current-parent* (cons (make-default-node 'text 'txt font str) (scene-node-children *current-parent*)))))))

  (define-primitive 'interact
    (lambda (exp env ctx)
      ;; 兼容 (interact 480 180 ...) 和 (interact (global) ...) 两种写法
      (let* ([header (if (list? (cadr exp)) (cadr exp) (list (cadr exp) (caddr exp)))]
             [body (if (list? (cadr exp)) (cddr exp) (cdddr exp))]
             [interact-node (make-default-node 'interact 'inter-grp #f '())]
             [processed-cases '()])
	(for-each 
	 (lambda (case-exp)
           (let* ([cond-list (let ([c (car case-exp)]) (if (list? c) c (list c)))]
                  [sub-group (make-default-node 'group 'case-grp #f #f)])
             ;; 为该分支创建独立的子树
             (let ([old-parent *current-parent*])
               (set! *current-parent* sub-group)
               (for-each (lambda (e) (eval e env ctx)) (cdr case-exp))
               (set! *current-parent* old-parent))
             ;; 存储格式：( (cond1 cond2 ...) . 子树节点 )
             (set! processed-cases (cons (cons cond-list sub-group) processed-cases))))
	 body)
	;; 在 data 槽位存储：(范围定义 . 处理后的分支列表)
	(scene-node-data-set! interact-node (list header (reverse processed-cases)))
	(scene-node-children-set! *current-parent* (cons interact-node (scene-node-children *current-parent*))))))

  (define-primitive 'color (lambda (exp env ctx) (call-with-render-context-mutated ctx `((color . ,(lambda (v) (list-head (cdr exp) 4)))) (lambda (c) (eval (car (reverse exp)) env c)))))
  (define-primitive 'font (lambda (exp env ctx) (call-with-render-context-mutated ctx `((font . ,(lambda (v) (cadr exp)))) (lambda (c) (eval (caddr exp) env c)))))
  (define-primitive 'size (lambda (exp env ctx) (call-with-render-context-mutated ctx `((size . ,(lambda (v) (cadr exp)))) (lambda (c) (eval (caddr exp) env c)))))
  (define-primitive 'spacing (lambda (exp env ctx) (call-with-render-context-mutated ctx `((spacing . ,(lambda (v) (cadr exp)))) (lambda (c) (eval (caddr exp) env c)))))

  (define-primitive 'jump   (lambda (exp env ctx) (set! *jump-signal* (cons 'jump (cadr exp)))))
  (define-primitive 'call   (lambda (exp env ctx) (set! *jump-signal* (cons 'call (cadr exp)))))
  (define-primitive 'return (lambda (exp env ctx) (set! *jump-signal* (cons 'return #f))))
  (define-primitive 'include (lambda (exp env ctx)
                               ;; include 是静态引入，直接在当前环境 eval 文件内容 [cite: 34, 35]
                               (let ([content (with-input-from-file (cadr exp) read)])
                                 (for-each (lambda (e) (eval e env ctx)) content))))

  ; typeface for SDF font
  (define-primitive 'typeface
  (lambda (exp env ctx)
    (let ([id (cadr exp)]
          [sub-exp (caddr exp)])
      ;; 在执行子指令前，先确保 GPU 纹理已就绪（主线程安全执行）
      (load-typeface-and-cache! id env) 
      (call-with-render-context-mutated ctx 
        `((typeface . ,(lambda (v) id))) ;; 暂存当前使用的 ID 到 context [cite: 9-10]
        (lambda (c) (eval sub-exp env c))))))

  (define-primitive 'label
  (lambda (exp env ctx)
    (let* ([str (cadr exp)]
           [tid ((record-field-accessor render-context 'typeface) ctx)])
      (let ([bundle (and tid (load-typeface-and-cache! tid env))])
	(when bundle
          ;; 这里的 payload 暂时传 ID，渲染时从 env 取 ready 的结果 [cite: 6-7, 87]
          (scene-node-children-set! *current-parent*
				    (cons (make-default-node 'label tid bundle str) 
					  (scene-node-children *current-parent*))))))))
)
