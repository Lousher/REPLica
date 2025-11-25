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
  (define layer-below?
    (lambda (a b) (< (car a) (car b))))
  (define make-action
    (lambda (animator end?)
      (lambda (state)
	(let ([layers (cdr (assv ':layers state))])
	  (let-values ([(bg-layers fg-layers) (partition (lambda (pair) (< (car pair) 0)) layers)])
	    (let ([bg-anis (map cdr (sort layer-below? bg-layers))]
		  [fg-anis (map cdr (sort layer-below? fg-layers))])
	    (let animating ([passed 0.0])
	      (BeginDrawing)
	      (ClearBackground BLACK)
	      (for-each (lambda (ani) (ani state)) bg-anis)
	      ((animator passed) state)
	      (for-each (lambda (ani) (ani state)) fg-anis)
	      (EndDrawing)
	      (cond
	       [(WindowShouldClose) (values 'done state)]
	       [(end? state passed)
		(let ([new-state (alist-update state ':previous (load-texture-from-screen))])
		  (collect 4)
		  (resource-collect)
		  (ffi-collect)
		  (values 'next new-state))]
	       [else (animating (+ passed (GetFrameTime)))]))))))))

  (define normal-action
    (lambda (animator)
      (make-action animator
		   (lambda (s p) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))))

  (define signal?
    (lambda (x)
      (and (pair? x)
	   (memv (car x) '(jump reload game-over error)))))

  (define action<-script
    (lambda (exp)
      (case (car exp)
	[(preload resource-clear lock unlock)
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
		     [current-state '((:layers . ())
				      (:resources . ())
				      (:previous . #f))])
	(TraceLog LOG_INFO (format-green "Replica: Loading Story ~a." current-script))
	(let ([raw-exps (call-with-input-file current-script reads)])
	  (let* ([strings (extract-strings raw-exps)]
		 [valid-strs (filter (lambda (s) (not (file-exists? s))) strings)])
	    (parameterize ([*story-text* (apply string-append valid-strs)])
	      (let* ([actions (map action<-script raw-exps)]
		     [stroying-action (sequence (filter procedure? actions))])
		(let-values ([(sig new-state) (stroying-action current-state)])
		  (TraceLog LOG_INFO (format-green "State is ~a" (assv ':layers new-state)))
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

