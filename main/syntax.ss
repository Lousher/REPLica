(define-syntax with-fullscreen
  (syntax-rules ()
    [(_ title rest ...)
     (let ([w (GetMonitorWidth 0)]
	   [h (GetMonitorHeight 0)]
	   [flags (logor FLAG_WINDOW_MAXIMIZED
			 FLAG_WINDOW_MINIMIZED
			 FLAG_WINDOW_RESIZABLE)])
       (SetConfigFlags flags)
       (SetTargetFPS 60)
       (InitWindow w h title)
       (InitAudioDevice)
       rest ...
       (CloseAudioDevice)
       (CloseWindow)
       )]))

(define-syntax drawing-loop
  (syntax-rules ()
    [(_ [updating ...] [drawing ...] [cleanup ...])
     (dynamic-wind
       (lambda () #f)
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
