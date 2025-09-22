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

; game state
(define GAME_RT_BG #f)
(define GAME_RT_DIALOG #f)
(define GAME_WIDTH_SCREEN 0)
(define GAME_HEIGHT_SCREEN 0)
(define GAME_DIALOG_ALPHA 0.5)

(define game-state-init
  (lambda ()
     (set! GAME_WIDTH_SCREEN (GetScreenWidth))
     (set! GAME_HEIGHT_SCREEN (GetScreenHeight))
     (set! GAME_RT_BG (LoadRenderTexture GAME_WIDTH_SCREEN GAME_HEIGHT_SCREEN))
     (set! GAME_RT_DIALOG (LoadRenderTexture GAME_WIDTH_SCREEN (round (/ GAME_HEIGHT_SCREEN 3))))
     ((update-dialog-given-wh GAME_WIDTH_SCREEN GAME_HEIGHT_SCREEN) "../assets/dialog/b.jpg")))

(define update-dialog-given-wh
  (lambda (w h)
    (let ([w w] [h h])
      (lambda (path)
	(let ([img (LoadImage path)])
	  (ImageResize img w (round (/ h 3)))
	  (let ([tex (LoadTextureFromImage img)])
	    (UnloadImage img)
	    (BeginTextureMode GAME_RT_DIALOG)
	    (ClearBackground BLACK)
	    (DrawTexture tex 0 0 WHITE)
	    (EndTextureMode)
	    (UnloadTexture tex)))))))

(define draw-bg-given-wh
  (lambda (w h)
    (let ([rect (make-Rectangle 0.0 0.0 (exact->inexact w) (exact->inexact (- h)))]
	  [default-vec (make-Vector2 0.0 0.0)])
      (lambda ()
	(DrawTextureRec
	 (RenderTexture-texture GAME_RT_BG)
	 rect default-vec WHITE)))))

(define draw-dialog-given-wh
  (lambda (w h)
    (let ([rect (make-Rectangle 0.0 0.0 (exact->inexact w) (exact->inexact (- (round (/ h 3)))))]
	  [default-vec (make-Vector2 0.0 (exact->inexact (* h 2/3)))])
      (lambda ()
	(DrawTextureRec
	 (RenderTexture-texture GAME_RT_DIALOG)
	 rect default-vec (Fade WHITE GAME_DIALOG_ALPHA))))))

(define update-bg-given-wh
  (lambda (w h)
    (let ([w w] [h h])
      (lambda (path)
	(let ([img (LoadImage path)])
	  (ImageResize img w h)
	  (let ([tex (LoadTextureFromImage img)])
	    (UnloadImage img)
	    (BeginTextureMode GAME_RT_BG)
	    (ClearBackground BLACK)
	    (DrawTexture tex 0 0 WHITE)
	    (EndTextureMode)
	    (UnloadTexture tex)))))))

(define main
  (lambda ()
    (with-fullscreen
     "缘心饲契"
     (game-state-init)
     (let* ([draw-bg (draw-bg-given-wh GAME_WIDTH_SCREEN GAME_HEIGHT_SCREEN)]
	    [update-bg (update-bg-given-wh GAME_WIDTH_SCREEN GAME_HEIGHT_SCREEN)]
	    [draw-dialog (draw-dialog-given-wh GAME_WIDTH_SCREEN GAME_HEIGHT_SCREEN)])
       (update-bg "../assets/bg/a.jpg")
       (drawing-loop
	[] ;updating logic
	[(draw-bg)
	 (draw-dialog)] ;drawing
	)))))
