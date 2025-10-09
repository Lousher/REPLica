(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "syntax.ss")
(load "tools.ss")
(load "assets.ss")

(define GAME_SPLIT 5)
(define DIALOG_ALPHA 0.4)
(define FILE_ALLTEXT "../scripts/allchars.txt")
(define FILE_FONT "../assets/font/Xiaolai-Regular.ttf")
(define TEXT_SHOWN 0)

(define draw-location
  (lambda (w h)
    (let ([prev ""]
	  [rt (LoadRenderTexture w h)]
	  [rect (make-Rectangle
		 0.0 0.0
		 (exact->inexact w)
		 (exact->inexact (- h)))]
	  [vec (make-Vector2 0.0 0.0)])
      (values 
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
			 rect vec WHITE))
       (lambda () UnloadRenderTexture rt)))))

(define draw-characters
  (lambda (w h)
    (let* ([prev (make-vector GAME_SPLIT 0)]
	   [_ (for-each (lambda (i) (vector-set! prev i `("" . ,(make-ftype-pointer Texture2D (foreign-alloc (ftype-sizeof Texture2D)))))) (iota GAME_SPLIT))]
	   [w-seg (/ w GAME_SPLIT)])
      (values
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
		       [ypos (- (* h 1.0) (Texture-height tex))]
		       [ypos-mov (+ ypos (* (sin (* (GetTime) 1.5)) 3.0))])
		  (DrawTextureV (cdr prev-i) (make-Vector2 xpos ypos-mov) WHITE)))))
	  vec-5
	  (list->vector (iota GAME_SPLIT))))
       (lambda () (vector-for-each (lambda (vec) (let ([tex (cdr vec)]) (UnloadTexture tex))) prev))
       ))))

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
	    (values 
	     (lambda (who text)
	       (DrawTextureRec (RenderTexture-texture rt) rect vec (Fade WHITE DIALOG_ALPHA))
	       (DrawTextEx font who name-vec 75.0 0.0 color)
	       (DrawTextEx font (TextSubtext text 0 (* 3 (floor (/ TEXT_SHOWN 10)))) text-vec size 0.0 color))
	     (lambda ()
	       (UnloadRenderTexture rt)
	       (UnloadFont font)))))))))

(define play-voice
  (lambda ()
    (let ([prev-sound (make-ftype-pointer Sound (foreign-alloc (ftype-sizeof Sound)))])
      (values
       (lambda (path)
	 (UnloadSound prev-sound)
	 (set! prev-sound (LoadSound path))
	 (PlaySound prev-sound))
       (lambda () (UnloadSound prev-sound))
       ))))

(define play-music
  (lambda ()
    (let ([music (make-ftype-pointer Music (foreign-alloc (ftype-sizeof Music)))])
      (values
       (lambda (path)
	 (UnloadMusicStream music)
	 (set! music (LoadMusicStream path))
	 (PlayMusicStream music))
       (lambda ()
	 (UpdateMusicStream music))
       (lambda (volume)
	 (SetMusicVolume music volume))
       (lambda () (UnloadMusicStream music))))))

(define replica
  (lambda (file)
    (with-fullscreen
     "缘心饲契"
     (let ([screen-width (GetScreenWidth)]
	   [screen-height (GetScreenHeight)])
       (let-values ([(render:location clear:location) (draw-location screen-width screen-height)]
		    [(render:characters clear:characters) (draw-characters screen-width screen-height)]
		    [(render:text clear:text) (draw-text screen-width screen-height)]
		    [(play:voice clear:voice) (play-voice)]
		    [(play:music update:music set-volume:music clear:music) (play-music)])
	 (play:music "../assets/bgm/midnight-trip.mp3")
	 (set! shader (LoadShader #f "../assets/glsl/fade.fs"))
	 (set! newTexture (LoadTexture "../assets/bg/b.jpg"))
	 (set! texture1Loc (GetShaderLocation shader "texture1"))
	 (set! progressLoc (GetShaderLocation shader "progress"))
	 (set! progress 0.0)
	 (set! passed 0.0)
	 (set! progress-addr (make-ftype-pointer float (foreign-alloc (ftype-sizeof float))))
	 (ftype-set! float () progress-addr 0 progress)
	 (drawing-loop
	  [(when (< progress 1.0)
	     (set! passed (+ passed (GetFrameTime)))
	     (set! progress (/ passed 3.0))
	     (ftype-set! float () progress-addr 0 progress))
	   (SetShaderValue shader progressLoc (ftype-pointer-address progress-addr) 0)
	   (update:music)
	   (unless (> TEXT_SHOWN 1000)
	     (set! TEXT_SHOWN (+ TEXT_SHOWN 2)))
	   (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	     (EndShaderMode)
	     )] ;updating
	  [(BeginShaderMode shader)
           (SetShaderValueTexture shader texture1Loc newTexture)
	   (render:location "../assets/bg/a.jpg")
	   (EndShaderMode)
	   ] ;drawing
	  [(clear:location)
	   (clear:characters)
	   (clear:text)
	   (clear:voice)
	   (clear:music)] ;cleaning
	  ))))))

(define shader:fade
  (lambda ()
    (with-fullscreen
     "Fade Shader"
     (let ([oldImg (LoadImage "../assets/bg/a.jpg")]
	   [newImg (LoadImage "../assets/bg/b.jpg")]
	   [fade (LoadShader #f "../assets/glsl/fade.fs")])
       (ImageResize oldImg (GetScreenWidth) (GetScreenHeight))
       (ImageResize newImg (GetScreenWidth) (GetScreenHeight))
       (let ([oldTex (LoadTextureFromImage oldImg)]
	     [newTex (LoadTextureFromImage newImg)])
	 (UnloadImage oldImg)
	 (UnloadImage newImg)
	 (let* ([texture1Loc (GetShaderLocation fade "texture1")]
		[progressLoc (GetShaderLocation fade "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)]
		[progress 0.0] [passed 0.0])
	   (ftype-set! float () progress-fptr progress)
	   (drawing-loop
	    [(set! passed (+ passed (GetFrameTime)))
	     (set! progress (/ passed 2.0))
	     (when (>= progress 1.0)
	       (set! progress 0.0)
	       (set! passed 0.0))
	     (ftype-set! float () progress-fptr progress)
	     (SetShaderValue fade progressLoc progress-ptr SHADER_UNIFORM_FLOAT)
	     ]
	    [(BeginShaderMode fade)
	     (SetShaderValueTexture fade texture1Loc newTex)
	     (DrawTexture oldTex 0 0 WHITE)
	     (EndShaderMode)]
	    [(foreign-free progress-ptr)
	     (UnloadTexture oldTex)
	     (UnloadTexture newTex)
	     (UnloadShader fade)])))))))
