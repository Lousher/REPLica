(load-shared-object "libraylib.5.5.0.dylib")
(load "raylib.ffi.ss")

(define FLAG_FULLSCREEN_MODE #x00000002)

(define BLACK (make-Color 0 0 0 255))
(define WHITE (make-Color 255 255 255 255))

(define LOG_ALL 0)
(define LOG_TRACE 1)
(define LOG_DEBUG 2)
(define LOG_INFO 3)
(define LOG_WARNING 4)
(define LOG_ERROR 5)
(define LOG_FATAL 6)
(define LOG_NONE 7)

(define-syntax with-fullscreen
  (syntax-rules ()
    [(_ title rest ...)
     (let ([w (GetMonitorWidth 0)]
	   [h (GetMonitorHeight 0)])
       (SetConfigFlags FLAG_FULLSCREEN_MODE)
       (SetTargetFPS 60)
       (InitWindow w h title)
       rest ...
       (CloseWindow)
       )]))

(define-syntax drawing-loop
  (syntax-rules ()
    [(_ [updating ...] [drawing ...])
     (let loop ()
       updating ...
       (unless (WindowShouldClose)
	 (BeginDrawing)
	 (ClearBackground BLACK)
	 drawing ...
	 (EndDrawing)
	 (loop)))]))

(define main
  (lambda ()
    (with-fullscreen
     "缘心饲契"
     (let* ([img (LoadImage "../assets/bg/a.jpg")]
	    [tex (LoadTextureFromImage img)])
       (UnloadImage img)
       (drawing-loop
	[]
	[(DrawTexturePro
	  tex
	  (make-Rectangle 0.0 0.0 (exact->inexact (Texture-width tex)) (exact->inexact (Texture-height tex)))
	  (make-Rectangle 0.0 0.0 (exact->inexact (GetMonitorWidth 0)) (exact->inexact (GetMonitorHeight 0)))
	  (make-Vector2 0.0 0.0)
	  0.0 WHITE
	  )])
       (UnloadTexture tex)))))
