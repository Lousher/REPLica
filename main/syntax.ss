(define-syntax with-fullscreen
  (syntax-rules ()
    [(_ title)
     (syntax-rules ()
       [(_ . rest)
	(let ([w (GetScreenWidth)]
	      [h (GetScreenHeight)]
	      [flags (logor FLAG_WINDOW_MAXIMIZED
			    FLAG_WINDOW_MINIMIZED
			    FLAG_WINDOW_RESIZABLE)])
	  (SetConfigFlags flags)
	  (SetTargetFPS 60)
	  (InitWindow w h title)
	  (InitAudioDevice)
	
	  (fluid-let ([*screen-width* (GetScreenWidth)]
		      [*screen-height* (GetScreenHeight)])
	    rest)
	  (CloseAudioDevice)
	  (CloseWindow))])]))

(define-syntax drawing-loop
  (syntax-rules ()
    [(_ pred [updating ...] [drawing ...])
     (let loop ()
       (BeginDrawing)
       (ClearBackground BLACK)
       drawing ...
       (EndDrawing)
       (when pred
	 updating ...)
       (loop))]))



