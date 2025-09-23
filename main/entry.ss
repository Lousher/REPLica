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

					; Game State
(define-record-type GameState
  (fields
   (immutable width)
   (immutable height)
   (mutable RT-BG)
   (mutable RT-Dialog)
   (mutable Tex-CH)
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
       (LoadRenderTexture w (round (/ h 3)))
       #f))))

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

(define ch-nums (map (lambda (x) (+ 894 x)) (iota (1+ (- 941 894)))))
(define ch-path (map (lambda (n) (format "0~a.png" n)) ch-nums))
(define full-ch-path (map (lambda (path) (string-append "../assets/character/" path)) ch-path))
(set-cdr! (last-pair full-ch-path) full-ch-path)

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
	 (set! BGM (LoadSound "../assets/va/1.new.ogg"))
	 (update-bg "../assets/bg/a.jpg")
	 (update-dialog "../assets/dialog/e.jpg")
	 (GameState-Tex-CH-set! state (LoadTexture (car full-ch-path)))
	 	   (PlaySound BGM)
	 (drawing-loop
	  [(when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	     (UnloadTexture (GameState-Tex-CH state))
	     (set! full-ch-path (cdr full-ch-path))
	     (GameState-Tex-CH-set! state (LoadTexture (car full-ch-path))))] ;updating logic
	  [(draw-bg)
	   (DrawTexture (GameState-Tex-CH state) 0 0 WHITE)
	   (draw-dialog)] ;drawing
	  [(UnloadRenderTexture bg-RT)
	   (UnloadRenderTexture dialog-RT)
	   (UnloadSound BGM)] ;cleaning
	  ))))))
