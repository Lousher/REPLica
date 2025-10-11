(define-syntax with-fullscreen
  (syntax-rules ()
    [(_ title rest ...)
     (let ([w (GetScreenWidth)]
	   [h (GetScreenHeight)]
	   [flags (logor FLAG_WINDOW_MAXIMIZED
			 FLAG_WINDOW_MINIMIZED
			 FLAG_WINDOW_RESIZABLE)])
       (SetConfigFlags flags)
       (SetTargetFPS 60)
       (InitWindow w h title)
       (InitAudioDevice)
       rest ...
       (CloseAudioDevice)
       (CloseWindow))]))

(define-syntax drawing-loop
  (syntax-rules ()
    [(_ [before ...] [updating ...] [drawing ...] [cleanup ...])
     (dynamic-wind
       (lambda ()
	 before ...)
       (lambda ()
	 (let loop ()
	   updating ...
	   (unless (WindowShouldClose)
	     (BeginDrawing)
	     (ClearBackground BLACK)
	     drawing ...
	     (EndDrawing)
	     (loop))))
       (lambda ()
	 cleanup ...))]))
