(library (rpl eval)
  (export eval render)
  (import (vm bundle)
	  (raylib ffi)
	  (raylib constant)
	  (except (chezscheme) eval)
	  (rename (chezscheme) (eval c:eval)))

  #| primitive
  (mount xxx)
  (assets
   (texture xxx xxx-path))
  (show xxx) ; assume that xxx is already loaded
  |#

  (define-record-type render-command
    (fields (mutable type)
	    (mutable id)
	    (mutable x) (mutable y)
	    (mutable w) (mutable h)
	    (mutable ox) (mutable oy)
	    (mutable scale)
	    (mutable rotation)
	    (mutable alpha)))

  (define-record-type render-context
    (fields (mutable x) (mutable y)
	    (mutable ox) (mutable oy)
	    (mutable ax) (mutable ay)
	    (mutable scale)
	    (mutable rotation)
	    (mutable alpha)))

  (define *current-bundles* #f)
  (define *command-list* '())
    
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
	[(parallel) ; (parallel (... 1) (... 2))
	 (for-each (lambda (sub-ren)
		     (eval sub-ren env ctx))
		   (cdr exp))]
	[(anchor) ; (anchor AX AY (...))
	 (let* ([ax (cadr exp)] [ay (caddr exp)]
		[sub (cadddr exp)]
		[new-ctx (make-render-context
                        (render-context-x ctx) (render-context-y ctx)
                        (render-context-ox ctx) (render-context-oy ctx)
                        ax ay ;; 注入新的锚点
                        (render-context-scale ctx)
                        (render-context-rotation ctx)
                        (render-context-alpha ctx))])
	   (eval sub env new-ctx))]
	[(origin) ; (origin OX OY (...))
	 (let* ([rx (cadr exp)] [ry (caddr exp)]
		[sub (cadddr exp)]
		[new-ctx (make-render-context
			  (render-context-x ctx) (render-context-y ctx)
			  rx ry
			  (render-context-ax ctx) (render-context-ay ctx)
			  (render-context-scale ctx)
			  (render-context-rotation ctx)
			  (render-context-alpha ctx))])
	   (eval sub env new-ctx))]
	[(scale) ; (scale X sub)
	 (let* ([s (cadr exp)] [sub (caddr exp)]
		[new-ctx (make-render-context
			  (render-context-x ctx) (render-context-y ctx)
			  (render-context-ox ctx) (render-context-oy ctx)
			  (render-context-ax ctx) (render-context-ay ctx)
			  (* (render-context-scale ctx) s)
			  (render-context-rotation ctx)
			  (render-context-alpha ctx))])
	   (eval sub env new-ctx))]
	[(rotate) ; (rotate DEG sub)
	 (let* ([deg (cadr exp)] [sub (caddr exp)]
		[new-ctx (make-render-context
			  (render-context-x ctx) (render-context-y ctx)
			  (render-context-ox ctx) (render-context-oy ctx)
			  (render-context-ax ctx) (render-context-ay ctx)
			  (render-context-scale ctx)
			  (+ (render-context-rotation ctx) deg) ;; 角度相加
			  (render-context-alpha ctx))])
	   (eval sub env new-ctx))]
	[(alpha) ; (alpha A (...))
	 (let* ([a (cadr exp)] [sub (caddr exp)]
		[new-ctx (make-render-context
			  (render-context-x ctx) (render-context-y ctx)
			  (render-context-ox ctx) (render-context-oy ctx)
			  (render-context-ax ctx) (render-context-ay ctx)
			  (render-context-scale ctx) (render-context-rotation ctx)
			  (* (render-context-alpha ctx) a))])
	   (eval sub env new-ctx))]
	[(at) ; (at X Y (...))
	 (let* ([offset-x (cadr exp)]
		[offset-y (caddr exp)]
		[sub-render (cadddr exp)]
		[new-ctx (make-render-context
			  (+ (render-context-x ctx) offset-x)
			  (+ (render-context-y ctx) offset-y)
			  (render-context-ox ctx) (render-context-oy ctx)
			  (render-context-ax ctx) (render-context-ay ctx)
			  (render-context-scale ctx)
			  (render-context-rotation ctx)
			  (render-context-alpha ctx))])
	   (eval sub-render env new-ctx)
	   )]
	[(show) ; (show TEXTURE-ID) in given ctx!!
	 (let* ([sym (cadr exp)]
		[entry (hashtable-ref env sym #f)])
	   (when (and entry *current-bundles*)
	     (let ([path (car entry)]
		   [cached (cdr entry)])
	       (let ([cached-tex (if cached cached 
				     (let-values ([(ext data len) (ref *current-bundles* path)])
				       (if data
					   (let* ([img (LoadImageFromMemory ext data len)]
						  [tex (LoadTextureFromImage img)])
					     (UnloadImage img)
					     (set-cdr! entry tex)
					     tex)
					   (begin
					     (TraceLog LOG_ERROR (format "Asset ~a Not Found" path))
					     #f))))])
		 (set! *command-list*
		       (let ([tex-w (Texture-width cached-tex)]
			     [tex-h (Texture-height cached-tex)])
			 (cons
			  (make-render-command
			   'TEXTURE
			   cached-tex
			   (+ (render-context-x ctx) (* 1920.0 (render-context-ax ctx)))
			   (+ (render-context-y ctx) (* 1080.0 (render-context-ay ctx)))
			   tex-w
			   tex-h
			   (* tex-w (render-context-ox ctx))
			   (* tex-h (render-context-oy ctx))
			   (render-context-scale ctx)
			   (render-context-rotation ctx)
			   (render-context-alpha ctx))
			  *command-list*)))))))]
	)))

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
		   [oy (/ (- sh (* 1080.0 scale)) 2.0)])
	      (BeginDrawing)
	      (ClearBackground WHITE)
	      (for-each (lambda (cmd)
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
			       (DrawTexturePro tex src-rect dest-rect origin rot tint))]))
			(reverse *command-list*))
	      (EndDrawing)
	      (loop)))))
      (when *current-bundles* (unmount *current-bundles*))
      (CloseWindow)
      ))
  )
