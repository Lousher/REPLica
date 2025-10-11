(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "syntax.ss")
(load "tools.ss")

(define GAME_SPLIT 5)
(define DIALOG_ALPHA 0.4)
(define FILE_ALLTEXT "../scripts/allchars.txt")
(define FILE_FONT "../assets/font/Xiaolai-Regular.ttf")
(define TEXT_SHOWN 0)
(define TRANSITION_DURATION 3.0)

(define *render:background* #f) ;texture
(define *render:character* #f) ;texture pos(like 1/5)
(define *screen-width* #f)
(define *screen-height* #f)
(define *background* #f)
(define scene #f)

(define ASSETS (make-hashtable string-hash string=?))

(define asset-cache
  (lambda (path)
    (if (hashtable-contains? ASSETS path)
	(hashtable-ref ASSETS path 'NULL)
	(let* ([img (LoadImage path)]
	       [_ (ImageResize img (GetScreenWidth) (GetScreenHeight))]
	       [tex (LoadTextureFromImage img)])
	  (UnloadImage img)
	  (hashtable-set! ASSETS path tex)
	  (asset-cache path)))))

(define asset-clear
  (lambda (path)
    (when (hashtable-contains? ASSETS path)
      (UnloadTexture (asset-cache path))
      (hashtable-delete! ASSETS path))))


(define draw-location
  (let ([origin (make-Vector2 0.0 0.0)])
    (lambda (tex)
      (let ([tex-w (Texture-width tex)]
	    [tex-h (Texture-height tex)])
	(let ([src-rec (make-Rectangle 0.0 0.0 (exact->inexact tex-w) (exact->inexact tex-h))]
	      [dst-rec (make-Rectangle 0.0 0.0 (exact->inexact *screen-width*) (exact->inexact *screen-height*))])
	  (DrawTexturePro tex src-rec dst-rec origin 0.0 WHITE))))))


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

(define texture-transformer
  (lambda (stx)
    (syntax-case stx ()
      [(_ name (diff path) ...)
       #'(define-syntax name
	   (make-variable-transformer
	    (lambda (x)
	      (syntax-case x (diff ...)
		[(id) #'(begin (asset-clear path) ...)]
		[(_ diff) #'(asset-cache path)] ...))))])))

(define replica
  (lambda (script)
    (let ([w (GetScreenWidth)] [h (GetScreenHeight)]
	  [flags (logor FLAG_WINDOW_MAXIMIZED
			FLAG_WINDOW_MINIMIZED
			FLAG_WINDOW_MAXIMIZED)])
      (SetConfigFlags flags)
      (SetTargetFPS 60)
      (InitWindow w h "缘心饲契")
      (InitAudioDevice)

      (fluid-let ([*screen-height* (GetScreenHeight)]
		  [*screen-width* (GetScreenWidth)]
		  [scene draw-location])
	(fluid-let-syntax ([texture texture-transformer])
	  (texture yuwen-bedroom (morning "../assets/bg/yuwen.bedroom.morning.png"))
	  (let loop ()
	    (unless (WindowShouldClose)
	      (BeginDrawing)
	      (ClearBackground BLACK)
	      (scene (yuwen-bedroom morning))
	      (EndDrawing)
	      (loop)))))
      
      (CloseAudioDevice)
      (CloseWindow))))

