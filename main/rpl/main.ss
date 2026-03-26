(library (rpl main)
  (export replica)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (vm main)
	  (vm asm)
	  (rpl scene)
	  (rpl render)
	  (rpl compile))

  (define FPS 60)
  (define frame-time (/ 1.0 FPS))

  (define reads
    (lambda (port)
      (let collect ([content (read port)] [result '()])
	(if (eof-object? content)
	    result
	    (collect (read port) (append result (list content)))))))
  
  (define replica
    (lambda (rpl-file)
      (init)
      (let ([scripts (call-with-input-file rpl-file reads)])
	(let-values ([(code consts) (assemble (compile-dsl scripts))])
	  (let ([vm (make code consts)])
	    (let loop ()
	      (unless (WindowShouldClose)
		(when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
		  (when (not (state-running? vm))
		    (state-running?-set! vm #t)))
		(let* ([start-time (GetTime)]
		       [sw (GetScreenWidth)] [sh (GetScreenHeight)]
		       [s (min (/ sw 1920.0) (/ sh 1080.0))]
		       [ox (/ (- sw (* 1920.0 s)) 2.0)] [oy (/ (- sh (* 1080.0 s)) 2.0)]
		       [mx (/ (- (GetMouseX) ox) s)] [my (/ (- (GetMouseY) oy) s)])
		  (run vm)
		  (BeginDrawing)
		  (ClearBackground BLACK)
		  (draw vm (state-scene-root vm) mx my s ox oy)
		  (EndDrawing)
		  (ffi-collect)
		  (let wait-loop ()
		    (when (< (- (GetTime) start-time) frame-time)
;		      (sleep (make-time 'time-duration 1000000 0)) ; control FPS manually
		      (wait-loop)))
		  (loop)))))))
      (uninit)))
  )
