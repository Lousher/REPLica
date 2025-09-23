(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

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

					; Game State
(define-record-type GameState
  (fields
   (immutable width)
   (immutable height)
   (mutable RT-BG)
   (mutable RT-Dialog)
   ))
					; draw config
(define-record-type DrawConfig
  (fields source position color))

(define game-state-init
  (lambda ()
    (let ([w (GetScreenWidth)]
	  [h (GetScreenHeight)])
      (make-GameState
       w h
       (LoadRenderTexture w h)
       (LoadRenderTexture w (round (/ h 3)))))))

(define draw<-RT<-DrawConfig
  (lambda (draw-config)
    (lambda (rt)
      (lambda ()
	(DrawTextureRec
	 (RenderTexture-texture rt)
	 (DrawConfig-source draw-config)
	 (DrawConfig-position draw-config)
	 (DrawConfig-color draw-config))))))

(define update<-RT<-wh
  (lambda (w h)
    (lambda (rt)
      (lambda (path)
	(let ([img (LoadImage path)])
	  (ImageResize img w h)
	  (let ([tex (LoadTextureFromImage img)])
	    (UnloadImage img)
	    (BeginTextureMode rt)
	    (ClearBackground BLACK)
	    (DrawTexture tex 0 0 WHITE)
	    (EndTextureMode)
	    (UnloadTexture tex)))))))

(define DrawConfig-BG-init
  (lambda ()
    (make-DrawConfig
     (make-Rectangle 0.0 0.0 (exact->inexact (GetScreenWidth)) (exact->inexact (- (GetScreenHeight))))
     (make-Vector2 0.0 0.0)
     WHITE)))

(define DrawConfig-Dialog-init
  (lambda ()
    (let ([h (GetScreenHeight)])
      (make-DrawConfig
       (make-Rectangle 0.0 0.0 (exact->inexact (GetScreenWidth)) (exact->inexact (- (round (/ h 3)))))
       (make-Vector2 0.0 (exact->inexact (* h 2/3)))
       (Fade WHITE 0.5)))))

(define main
  (lambda ()
    (with-fullscreen
     "缘心饲契"
     (let* ([state (game-state-init)]
	    [screen-w (GameState-width state)]
	    [screen-h (GameState-height state)]
	    [bg-RT (GameState-RT-BG state)]
	    [dialog-RT (GameState-RT-Dialog state)])
       (let ([draw-bg ((draw<-RT<-DrawConfig (DrawConfig-BG-init)) bg-RT)]
	     [update-bg ((update<-RT<-wh screen-w screen-h) bg-RT)]
	     [draw-dialog ((draw<-RT<-DrawConfig (DrawConfig-Dialog-init)) dialog-RT)]
	     [update-dialog ((update<-RT<-wh screen-w (round (/ screen-h 3))) dialog-RT)])
	 (update-bg "../assets/bg/a.jpg")
	 (update-dialog "../assets/dialog/e.jpg")
	 (drawing-loop
	  [] ;updating logic
	  [(draw-bg)
	   (draw-dialog)] ;drawing
	  ))))))
