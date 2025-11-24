(library (replica)
  (export replica)
  (import (tool)
	  (raylib ffi)
	  (raylib constant)
	  (monad)
	  (primitive)
	  (chezscheme))

  (define script-env
    (environment '(chezscheme) '(primitive) '(monad) '(raylib constant) '(combinator)))

  (define make-action
    (lambda (animator end?)
      (lambda (state)
	(let animating ([passed 0.0])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  ((animator passed) state)
	  (EndDrawing)
	  (cond
	   [(WindowShouldClose) (values 'done state)]
	   [(end? state passed)
	    (let ([new-state (alist-update state ':previous (load-texture-from-screen))])
	      (collect 4)
	      (resource-collect)	      
	      (ffi-collect)
	      (values 'next new-state))]
	   [else (animating (+ passed (GetFrameTime)))])))))

  (define normal-action
    (lambda (animator)
      (make-action animator
		   (lambda (s p) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))))
    
  (define *story-text* #f)

  (define signal?
    (lambda (x)
      (and (pair? x)
	   (memv (car x) '(jump reload game-over error)))))

  (define action<-script
    (lambda (exp)
      (case (car exp)
	[(preload resource-clear)
	 (eval exp script-env)]
	[(define define-syntax import)
	 (eval exp script-env) #f]
	[else
	 (normal-action (eval exp script-env))])))
  
  (define replica
    (lambda (entry-file)
      (InitWindow (GetScreenWidth) (GetScreenHeight) "test")
      (InitAudioDevice)
      (SetTargetFPS 60)
      (let storying ([current-script entry-file]
		     [current-state '((:locked . ())
				      (:resources . ())
				      (:previous . #f))])
	(TraceLog LOG_INFO (format-green "Replica: Loading Story ~a." current-script))
	(let ([raw-exps (call-with-input-file current-script reads)])
	  (let* ([strings (extract-strings raw-exps)]
		 [valid-strs (filter (lambda (s) (not (file-exists? s))) strings)])
	    (fluid-let ([*story-text* (apply string-append valid-strs)])
	      (let* ([actions (map action<-script raw-exps)]
		     [stroying-action (sequence (filter procedure? actions))])
		(let-values ([(sig new-state) (stroying-action current-state)])
		  (let ([clean-state (alist-update new-state ':resources '())])
		    (collect)
		    (resource-collect)
		    (ffi-collect)
		    (case (if (pair? sig) (car sig) sig)
		      [(jump)
		       (let ([next-script (cadr sig)])
			 (TraceLog LOG_INFO (format-green "Replica: Jumping to ~a." next-script))
			 (storying next-script clean-state))]
		      [(done)
		       (TraceLog LOG_INFO (format-green "Replica: Game finished normally."))]
		      [else
		       (TraceLog LOG_WARNING (format-red "Replica: Unknow Signal ~a." sig))])))))))
	(CloseAudioDevice)
	(CloseWindow))))
  )

