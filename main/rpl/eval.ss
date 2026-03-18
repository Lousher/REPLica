(library (rpl eval)
  (export eval render)
  (import (vm bundle)
	  (raylib ffi)
	  (raylib constant)
	  (only (chezscheme csv7) record-field-mutator record-field-accessor)
	  (except (chezscheme) eval)
	  (rename (chezscheme) (eval c:eval)))

  #| primitive
  (mount xxx)
  (assets
   (texture xxx xxx-path))
  (show xxx) ; assume that xxx is already loaded

  combinator
  (at X Y (...))
  (origin OX OY (...))
  |#

  (define-record-type frame-state
    (fields mx my))

  (define compile-predicate
    (lambda (exp ctx)
      (if (eqv? 'else exp) (lambda (f) #t)
	  (case (car exp)
	    [(hovered?)
	     (let* ([w (cadr exp)] [h (caddr exp)]
		    [vals (render-context-fields-accessor ctx '(x y scale))]
		    [hx (car vals)] [hy (cadr vals)] [s (caddr vals)]
		    [hitbox (list hx hy (* w s) (* h s))])
	       (lambda (f)
		 (let ([mx (frame-state-mx f)] [my (frame-state-my f)])
		   (and (>= mx hx) (<= mx (+ hx (* w s)))
			(>= my hy) (<= my (+ hy (* h s)))))))]
	    [else (lambda (f) #t)]))))

  (define *uid* 0)
  (define gen-uid (lambda () (set! *uid* (+ 1 *uid*)) *uid*))

  (define-record-type branch-command
    (fields id cases))

  (define-record-type render-command
    (fields (mutable type) (mutable id)
	    (mutable x) (mutable y)
	    (mutable w) (mutable h)
	    (mutable ox) (mutable oy)
	    (mutable scale)
	    (mutable rotation)
	    (mutable alpha)))

  (define render-context-fields '(x y ox oy ax ay scale rotation alpha))
  (define render-context
    (make-record-type
     "render-context"
     render-context-fields))
  (define make-render-context
    (record-constructor render-context))
  (define render-context?
    (record-predicate render-context))

  (define render-context-fields-accessor
    (lambda (rc fs)
      (map (lambda (f) ((record-field-accessor render-context f) rc)) fs)))

  (define render-context-fields-mutator
    (lambda (rc fs vs)
      (for-each (lambda (f v) ((record-field-mutator render-context f) rc v)) fs vs)))

  (define call-with-render-context-mutated
    (lambda (rc mus proc)
      (let ([fs (map car mus)]
	    [mutators-f (map cdr mus)])
	(let* ([vals (render-context-fields-accessor rc fs)])
	  (render-context-fields-mutator rc fs (map (lambda (m v) (m v)) mutators-f vals))
	  (proc rc)
	  (render-context-fields-mutator rc fs vals)))))

  (define *current-bundles* #f)
  (define *command-list* '())

  ;; helper func
  (define load-and-cache!
    (lambda (entry)
      (let-values ([(ext data len) (ref *current-bundles* (car entry))])
	(if data
	    (let* ([img (LoadImageFromMemory ext data len)]
		   [tex (LoadTextureFromImage img)])
		  (UnloadImage img)
		  (set-cdr! entry tex)
		  tex)
		(begin
		  (TraceLog LOG_ERROR (format "Asset ~a Not Found" (car entry)))
		  #f)))))

  (define substitute
    (lambda (tree bindings)
      (cond
       [(null? tree) '()]
       [(symbol? tree)
	(let ([b (assq tree bindings)])
	  (if b (cdr b) tree))]
       [(pair? tree)
	(cons (substitute (car tree) bindings)
	      (substitute (cdr tree) bindings))]
       [else tree])))
    
  (define eval
    (lambda (exp env ctx)
      (case (car exp)
	[(bundle)
	 (set! *current-bundles* (mount (cadr exp)))]
	[(assets)
	 (for-each (lambda (def)
		     (let ([name (cadr def)] [path (caddr def)])
		       (hashtable-set! env name (cons path #f))))
		   (cdr exp))]
	[(prefab) ; (prefab name args body)
	 (let* ([name (cadr exp)]
		[args (caddr exp)]
		[body (cadddr exp)])
	   (hashtable-set! env name (list 'prefab args body)))]
	[(branch) ; (branch [(hovered? X Y) (...)] [else (...)])
	 (let ([branches (cdr exp)]
	       [saved-commands *command-list*])
	   (let ([compiled-cases
		  (map (lambda (b)
			 (let ([pred-exp (car b)]
			       [body-exp (cadr b)])
			   (let ([pred-fn (compile-predicate pred-exp ctx)])
			     (set! *command-list* '())
			     (eval body-exp env ctx)
			     (let ([cmds (reverse *command-list*)])
			       (cons pred-fn cmds)))))
		       branches)])
	     (set! *command-list* saved-commands)
	     (set! *command-list*
		   (cons (make-branch-command (gen-uid) compiled-cases) *command-list*))))]
	[(parallel) ; (parallel (... 1) (... 2))
	 (for-each (lambda (sub)
		     (eval sub env ctx))
		   (cdr exp))]
	[(anchor) ; (anchor AX AY (...))
	 (let* ([ax (cadr exp)] [ay (caddr exp)]
		[sub (cadddr exp)])
	   (call-with-render-context-mutated
	    ctx `((ax . ,(lambda (v) ax)) (ay . ,(lambda (v) ay)))
	    (lambda (new-ctx)
	      (eval sub env new-ctx))))]
	[(origin) ; (origin OX OY (...))
	 (let* ([rx (cadr exp)] [ry (caddr exp)]
		[sub (cadddr exp)])
	   (call-with-render-context-mutated
	    ctx `((ox . ,(lambda (v) rx)) (oy . ,(lambda (v) ry)))
	    (lambda (new-c)
	      (eval sub env new-c))))]
	[(scale) ; (scale X sub)
	 (let* ([s (cadr exp)] [sub (caddr exp)])
	   (call-with-render-context-mutated
	    ctx `((scale . ,(lambda (v) (* v s))))
	    (lambda (c)
	      (eval sub env c))))]
	[(rotate) ; (rotate DEG sub)
	 (let* ([deg (cadr exp)] [sub (caddr exp)])
	   (call-with-render-context-mutated
	    ctx `((rotation . ,(lambda (v) (+ v deg))))
	    (lambda (c) (eval sub env c))))]
	[(alpha) ; (alpha A (...))
	 (let* ([a (cadr exp)] [sub (caddr exp)])
	   (call-with-render-context-mutated
	    ctx `((alpha . ,(lambda (v) (* v a))))
	    (lambda (c) (eval sub env c))))]
	[(at) ; (at X Y (...))
	 (let* ([offset-x (cadr exp)]
		[offset-y (caddr exp)]
		[sub (cadddr exp)])
	   (call-with-render-context-mutated
	    ctx `((x . ,(lambda (v) (+ v offset-x)))
		  (y . ,(lambda (v) (+ v offset-y))))
	    (lambda (c) (eval sub env c))))]
	[(show) ; (show TEXTURE-ID) in given ctx!!
	 (let* ([sym (cadr exp)]
		[entry (hashtable-ref env sym #f)])
	   (when (and entry *current-bundles*)
	     (let ([path (car entry)]
		   [cached (or (cdr entry) (load-and-cache! entry))])
	       (when cached
		 (let ([ctx-vals (render-context-fields-accessor ctx render-context-fields)])
		   (apply (lambda (x y ox oy ax ay s r a)
			    (let ([tw (Texture-width cached)]
				  [th (Texture-height cached)])
			      (set! *command-list*
				    (cons
				     (make-render-command
				      'TEXTURE cached
				      (+ x (* 1920.0 ax)) (+ y (* 1080.0 ay))
				      tw th (* tw ox) (* th oy)
				      s r a)
				     *command-list*))))
			  ctx-vals))))))]
	[else
	 (let* ([op (car exp)]
		[prefab-def (hashtable-ref env op #f)])
	   (if (and prefab-def (eq? (car prefab-def) 'prefab))
	       (let* ([args (cadr prefab-def)]
		      [body (caddr prefab-def)]
		      [params (cdr exp)]
		      [bindings (map cons args params)]
		      [evaled (substitute body bindings)])
		 (eval evaled env ctx))
	       (error 'eval "Unknow primitive or prefab" op)))]
	)))


  (define consume
    (lambda (cmds frame scale ox oy)
      (for-each
       (lambda (cmd)
	 (cond
	  [(render-command? cmd)
	   (case (render-command-type cmd)
	     [(TEXTURE)
	      (let* ([tex (render-command-id cmd)]
		     [final-x (+ (* (render-command-x cmd) scale) ox)]
		     [final-y (+ (* (render-command-y cmd) scale) oy)]
		     [final-scale (* (render-command-scale cmd) scale)]
		     [rot (render-command-rotation cmd)]
		     [alpha (render-command-alpha cmd)]
		     [src-rect (make-rectangle 0.0 0.0 (render-command-w cmd) (render-command-h cmd))]
		     [dest-rect (make-rectangle final-x final-y
						(* (render-command-w cmd) final-scale)
						(* (render-command-h cmd) final-scale))]
		     [origin (make-vector2 (* (render-command-ox cmd) final-scale)
					   (* (render-command-oy cmd) final-scale))]
		     [tint (Fade WHITE alpha)])
		(DrawTexturePro tex src-rect dest-rect origin rot tint))])]
	  [(branch-command? cmd)
	   (let loop ([cases (branch-command-cases cmd)])
	     (unless (null? cases)
	       (let* ([ca (car cases)]
		      [pred (car ca)]
		      [sub-cmds (cdr ca)])
		 (if (pred frame)
		     (consume sub-cmds frame scale ox oy)
		     (loop (cdr cases))))))]))
       cmds)))
	 
  (define render
    (lambda (scripts)
      (InitWindow 1280 720 "RPL - Adaptive Display")
      (SetTargetFPS 60)
      (let ([env (make-hashtable symbol-hash symbol=?)]
	    [ctx (make-render-context 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 1.0)])
	(set! *command-list* '())
	(for-each (lambda (exp) (eval exp env ctx)) scripts)
	(let loop ()
	  (unless (WindowShouldClose)
	    (let* ([sw (GetScreenWidth)]
		   [sh (GetScreenHeight)]
		   [scale (min (/ sw 1920.0) (/ sh 1080.0))]
		   [ox (/ (- sw (* 1920.0 scale)) 2.0)]
		   [oy (/ (- sh (* 1080.0 scale)) 2.0)]
		   [logic-mouse-x (/ (- (GetMouseX) ox) scale)]
		   [logic-mouse-y (/ (- (GetMouseY) oy) scale)]
		   [f (make-frame-state logic-mouse-x logic-mouse-y)])
	      (BeginDrawing)
	      (ClearBackground WHITE)
	      (consume (reverse *command-list*) f scale ox oy)
	      (EndDrawing)
	      (loop)))))
      (when *current-bundles* (unmount *current-bundles*))
      (CloseWindow)
      ))

  )
