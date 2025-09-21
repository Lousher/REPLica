(load-shared-object "libraylib.5.5.0.dylib")
(load "raylib.ffi.ss")

(define FLAG_FULLSCREEN_MODE #x00000002)

(define BLACK (make-color 0 0 0 255))
(define WHITE (make-color 255 255 255 255))

(define LOG_ALL 0)
(define LOG_TRACE 1)
(define LOG_DEBUG 2)
(define LOG_INFO 3)
(define LOG_WARNING 4)
(define LOG_ERROR 5)
(define LOG_FATAL 6)
(define LOG_NONE 7)

(define init-fullscreen
  (lambda (title)
    (let ([width (GetMonitorWidth 0)]
	  [height (GetMonitorHeight 0)])
      (SetConfigFlags FLAG_FULLSCREEN_MODE)
      (InitWindow width height title)
      (SetTargetFPS 60)
      )))

(define display-image
  (lambda (path)
    (unless (IsWindowReady)
      (TraceLog LOG_WARNING "Must call init before"))

    (let* ([img (LoadImage path)]
	   [texture (LoadTextureFromImage img)])
      (UnloadImage img)

      (let loop ()
	(let ([close? (WindowShouldClose)])
	  (unless close?
	    (BeginDrawing)
	    (ClearBackground BLACK)
	    (DrawTexture texture 0 0 WHITE)
	    (EndDrawing)
	    (loop))))

      (UnloadTexture texture)
      (CloseWindow))))

(define main
  (lambda ()
    (init-fullscreen "Test Fullscreen")
    (display-image "../assets/bg/livingroom.jpg")))
