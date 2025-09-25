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
   (mutable characters)
   (mutable BGM)
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
       (make-eq-hashtable)
       "../assets/bgm/midnight-trip.mp3"))))

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

(define GAME_SPLIT 5)
(define symbols->symbol
  (lambda syms
    (let ([strs (map symbol->string syms)])
      (string->symbol
       (fold-left
       (lambda (acc next)
	 (string-append acc "-" next))
       (car strs)
       (cdr strs))))))

(define draw-CH<-ht<-wh
  (lambda (w h)
    (let* ([w-seg (/ w GAME_SPLIT)]
	   [center-positions (map (lambda (index) (+ (/ w-seg 2.0) (* index w-seg))) (iota GAME_SPLIT))])
     (lambda (ch-table)
      (lambda (i . selectors)
	(assert (< i GAME_SPLIT))
	(let* ([tex (hashtable-ref ch-table (apply symbols->symbol selectors) 'NotFound)]
	       [xPos (- (list-ref center-positions i) (/ (Texture-width tex) 2.0))]
	       [yPos (- (* h 1.0) (Texture-height tex))])
	  (DrawTextureV tex (make-Vector2 xPos yPos) WHITE)))))))

(define update-CH<-ht
  (lambda (ch-ht)
    (lambda (path . selectors)
      (let ([tex (LoadTexture path)])
	(hashtable-set! ch-ht (apply symbols->symbol selectors) tex)))))

(define main
  (lambda ()
    (with-fullscreen
     "缘心饲契"
     (let* ([state (game-state-init)]
	    [screen-w (GameState-width state)]
	    [screen-h (GameState-height state)]
	    [bg-RT (GameState-RT-BG state)]
	    [dialog-RT (GameState-RT-Dialog state)]
	    [ch-table (GameState-characters state)]
	    )
       (let ([draw-bg ((draw<-RT<-DrawConfig (DrawConfig-BG-init)) bg-RT)]
	     [update-bg ((update<-RT<-wh screen-w screen-h) bg-RT)]
	     [draw-dialog ((draw<-RT<-DrawConfig (DrawConfig-Dialog-init)) dialog-RT)]
	     [update-dialog ((update<-RT<-wh screen-w (round (/ screen-h 3))) dialog-RT)]
	     [draw-ch ((draw-CH<-ht<-wh screen-w screen-h) ch-table)]
	     [update-ch (update-CH<-ht ch-table)])
	 (let* ([all-text (LoadFileText "./allchars.txt")]
		[codepoint-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
		[codepoints (LoadCodepoints all-text codepoint-count)])
	   (set! FONT (LoadFontEx "../assets/font/Circle.otf" 56 codepoints (ftype-ref int () codepoint-count))))
	 (set! BGM (LoadSound "../assets/bgm/midnight-trip.mp3"))
	 (set! VA (LoadSound "../assets/va/1.new.ogg"))
	 (update-bg "../assets/bg/a.jpg")
	 (update-dialog "../assets/dialog/e.jpg")
	 (update-ch "../assets/character/0895.png" 'yuki 'smile)
	 (set! POS (cons 100.0 100.0))
	 (PlaySound BGM)
	 (drawing-loop
	  [(when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	     (PlaySound VA))
	   (cond
	    [(IsKeyPressed KEY_DOWN)
	     (set-cdr! POS (+ 10 (cdr POS)))]
	    [(IsKeyPressed KEY_UP)
	     (set-cdr! POS (- 10 (cdr POS)))]
	    [(IsKeyPressed KEY_LEFT)
	     (set-car! POS (- 10 (car POS)))]
	    [(IsKeyPressed KEY_RIGHT)
	     (set-car! POS (+ 10 (car POS)))])
	   ] ;updating logic
	  [(draw-bg)
	   (draw-ch 2 'yuki 'smile)
	   (DrawTextEx FONT (format "你好世界 ~a ~a" (car POS) (cdr POS))
		       (make-Vector2 (car POS) (cdr POS)) 56.0 0.0 WHITE)
;	   (draw-ch 4 'yuki 'suprise)
	   (draw-dialog)] ;drawing
	  [(UnloadRenderTexture bg-RT)
	   (UnloadRenderTexture dialog-RT)
	   (UnloadSound BGM)] ;cleaning
	  ))))))
