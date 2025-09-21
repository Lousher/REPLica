(load-shared-object "libraylib.5.5.0.dylib")
(load "raylib.ffi.ss")

(define FLAG_FULLSCREEN_MODE #x00000002)
(define FLAG_WINDOW_RESIZABLE #x00000004)
(define FLAG_WINDOW_MINIMIZED #x00000200)
(define FLAG_WINDOW_MAXIMIZED #x00000400)

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

(define RECTANGLE-TEXTURE-FULL-DEFAULT
  (lambda (tex)
    (let ([w (Texture-width tex)]
	  [h (Texture-height tex)])
      (make-Rectangle 0.0 0.0
		      w h))))

(define RECTANGLE-SCREEN-FULL-DEFAULT
  (lambda ()
    (let ([w (GetScreenWidth)]
	  [h (GetScreenHeight)])
      (make-Rectangle 0.0 0.0 w h))))

(define main
  (lambda ()
    (with-fullscreen
     "缘心饲契"
     (let* ()
       (drawing-loop
	[] ;updating
	[])))))
