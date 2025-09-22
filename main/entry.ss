(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
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
     (let* ([screen-w (GetScreenWidth)]
	    [screen-h (GetScreenHeight)]
	    [bg-RT (LoadRenderTexture screen-w screen-h)]
	    [bg-img (LoadImage "../assets/bg/a.jpg")]
	    [_ (ImageResize bg-img screen-w screen-h)]
	    [bg-tex (LoadTextureFromImage bg-img)])
       (UnloadImage bg-img)
       (BeginTextureMode bg-RT)
       (ClearBackground BLACK)
       (DrawTexture bg-tex 0 0 WHITE)
       (EndTextureMode)
       (UnloadTexture bg-tex)
       (drawing-loop
	[] ;updating
	[(DrawTextureRec
	  (RenderTexture-texture bg-RT)
	  (make-Rectangle 0.0 0.0
			  (exact->inexact screen-w)
			  (exact->inexact (- screen-h)))
	  (make-Vector2 0.0 0.0)
	  WHITE)]
       )))))
