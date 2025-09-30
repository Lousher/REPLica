(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "syntax.ss")

(define GAME_SPLIT 5)
(define DIALOG_ALPHA 0.5)
(define FILE_ALLTEXT "./allchars.txt")
(define FILE_FONT "../assets/font/Circle.otf")

(asset music
       (midnight "../assets/bgm/midnight-trip.mp3"))

(asset station
       (morning "../assets/bg/a.jpg")
       (afternoon "../assets/bg/b.jpg")
       (evening "../assets/bg/c.jpg")
       (night "../assets/bg/d.jpg"))

(asset yuki
       (smile "../assets/character/0895.png")
       (happy "../assets/character/0898.png")
       (first "../assets/va/1.new.ogg")
       (second "../assets/va/2.new.ogg"))

(define symbols->symbol
  (lambda syms
    (let ([strs (map symbol->string syms)])
      (string->symbol
       (fold-left
	(lambda (acc next)
	  (string-append acc "-" next))
	(car strs)
	(cdr strs))))))

(define draw-location
  (lambda (w h)
    (let ([prev ""]
	  [rt (LoadRenderTexture w h)]
	  [rect (make-Rectangle
		 0.0 0.0
		 (exact->inexact w)
		 (exact->inexact (- h)))]
	  [vec (make-Vector2 0.0 0.0)])
      (lambda (path)
	(unless (string=? prev path)
	  (let ([img (LoadImage path)])
	    (ImageResize img w h)
	    (let ([tex (LoadTextureFromImage img)])
	      (UnloadImage img)
	      (BeginTextureMode rt)
	      (ClearBackground BLACK)
	      (DrawTexture tex 0 0 WHITE)
	      (EndTextureMode)
	      (UnloadTexture tex))
	    (set! prev path)))
	(DrawTextureRec (RenderTexture-texture rt)
			rect vec WHITE)))))

(define draw-characters
  (lambda (w h)
    (let* ([prev (make-vector GAME_SPLIT 0)]
	   [_ (for-each (lambda (i) (vector-set! prev i `("" . ,(make-ftype-pointer Texture2D (foreign-alloc (ftype-sizeof Texture2D)))))) (iota GAME_SPLIT))]
	   [w-seg (/ w GAME_SPLIT)])
      (lambda (vec-5)
	(vector-for-each
	 (lambda (vec i)
	   (when vec
	     (let ([prev-i (vector-ref prev i)])
	       (unless (equal? (car prev-i) vec)
		 (UnloadTexture (cdr prev-i))
		 (foreign-free (ftype-pointer-address (cdr prev-i)))
		 (set-cdr! prev-i (LoadTexture vec))
		 (set-car! prev-i vec))
	       (let* ([tex (cdr prev-i)]
		      [xpos (- (+ (/ w-seg 2.0) (* i w-seg)) (/ (Texture-width tex) 2.0))]
		      [ypos (- (* h 1.0) (Texture-height tex))])
		 (DrawTextureV (cdr prev-i) (make-Vector2 xpos ypos) WHITE)))))
	 vec-5
	 (list->vector (iota GAME_SPLIT)))))))

(define draw-text
  (lambda (w h)
    (let ([rt (LoadRenderTexture w (round (/ h 3)))]
	  [rect (make-Rectangle
		 0.0 0.0
		 (exact->inexact w)
		 (exact->inexact (- (round (/ h 3)))))]
	  [vec (make-Vector2 0.0 (exact->inexact (* h 2/3)))])
      (let ([img (LoadImage "../assets/dialog/e.jpg")])
	(ImageResize img w (round (/ h 3)))
	(let ([tex (LoadTextureFromImage img)])
	  (UnloadImage img)
	  (BeginTextureMode rt)
	  (ClearBackground BLACK)
	  (DrawTexture tex 0 0 WHITE)
	  (EndTextureMode)
	  (UnloadTexture tex))
	(let* ([all-text (LoadFileText FILE_ALLTEXT)]
	       [codepoint-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
	       [codepoints (LoadCodepoints all-text codepoint-count)]
	       [font (LoadFontEx FILE_FONT 50 codepoints (ftype-ref int () codepoint-count))])
	  (foreign-free (ftype-pointer-address codepoint-count))
	  (UnloadCodepoints codepoints)
	  (UnloadFileText all-text)
	  (let* ([x 0.0] [y (* h 2/3 1.0)]
		 [size 50.0] [color WHITE]
		 [text-vec (make-Vector2 (+ x 100) (+ y 50))]
		 [name-vec (make-Vector2 (+ x 100) (- y 50))])
	    (lambda (who . text)
	      (DrawTextureRec (RenderTexture-texture rt) rect vec (Fade WHITE DIALOG_ALPHA))
	      (DrawTextEx font who name-vec 75.0 0.0 color)
	      (for-each (lambda (t)
			  (DrawTextEx font t text-vec size 0.0 color))
			text))))))))

(define play-voice
  (let ([prev-sound (make-ftype-pointer Sound (foreign-alloc (ftype-sizeof Sound)))])
    (lambda (path)
      (UnloadSound prev-sound)
      (set! prev-sound (LoadSound path))
      (PlaySound prev-sound))))


(define main
  (lambda ()
    (with-fullscreen
     "缘心饲契"
     (let ([screen-width (GetScreenWidth)]
	   [screen-height (GetScreenHeight)])
       (let ([render:location (draw-location screen-width screen-height)]
	     [render:characters (draw-characters screen-width screen-height)]
	     [render:text (draw-text screen-width screen-height)]
	     [play:voice play-voice])
	 (let ([scene-render (read-scene (scene :location (station morning)
			      :characters `#(#f #f ,(yuki smile) #f #f)
			      :voice (yuki first)
			      :text "苏喻文" "真是厉害啊"))])
	 (drawing-loop
	  [] ;updating logic
	  [(scene-render)] ;drawing
	  [(void)] ;cleaning
	  )))))))

