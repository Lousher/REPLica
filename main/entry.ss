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

(define *assets* #f)

(define file-suffix
  (lambda (name)
    (let ([len (string-length name)])
      (let col ([i (- len 1)] [res '()])
	(let ([ch (string-ref name i)])
	  (if (char=? #\. ch)
	      (list->string res)
	      (col (- i 1) (cons ch res))))))))

(define asset-cache
  (lambda (path)
    (if (hashtable-contains? *assets* path)
	(hashtable-ref *assets* path 'NULL)
	(begin
	  (case (file-suffix path)
	    [("png" "jpg")
	     (let* ([img (LoadImage path)]
		    [_ (ImageResize img (GetScreenWidth) (GetScreenHeight))]
		    [tex (LoadTextureFromImage img)])
	       (UnloadImage img)
	       (hashtable-set! *assets* path tex))]
	    [("ogg")
	     (hashtable-set! *assets* path (LoadSound path))]
	    [("mp3" "wav")
	     (hashtable-set! *assets* path (LoadMusicStream path))]
	    [else (error 'asset-cache "Not a valid asset type!")])
	  (asset-cache path)))))

(define asset-delete
  (lambda (path)
    (when (hashtable-contains? *assets* path)
      (let ([resource (asset-cache path)])
	(case (file-suffix path)
	  [("png" "jpg") (UnloadTexture resource)]
	  [("ogg") (UnloadSound resource)]
	  [("mp3" "wav") (UnloadMusicStream resource)])
	(hashtable-delete! *assets* path)))))

(define asset-clear
  (lambda ()
    (let ([paths (hashtable-keys *assets*)])
      (vector-for-each asset-delete paths))))

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

(define asset-script '(assets
		       (bedroom (morning "../assets/bg/yuwen.bedroom.morning.png"))
		       (yuki (smile "../assets/character/0895.png"))
		       (yuki-va (first "../assets/va/1.new.ogg"))
		       (midnight "../assets/bgm/midnight-trip.mp3")))

(define load-resource
  (lambda (path)
    (let ([suffix (file-suffix path)])
      (case suffix
	[("png" "jpg")
	 (let ([img (LoadImage path)])
	   (ImageResize img *screen-width* *screen-height*)
	   (let ([tex (LoadTextureFromImage img)])
	     (UnloadImage img)
	     tex))]
	[("ogg") (LoadSound path)]
	[("mp3" "wav") (LoadMusicStream path)]
	[else (error 'load-resource "Not a valid resource type")]))))
(define ftype-pointer->ftype-symbol
  (let* ([prefix "#<ftype-pointer"]
	 [start (string-length prefix)])
    (lambda (fptr)
      (let* ([str (with-output-to-string (lambda () (display fptr)))]
	     [len (string-length str)])
	(let find ([end (- len 1)])
	  (if (char=? #\space (string-ref str end))
	      (string->symbol (substring str (+ start 1) end))
	      (find (- end 1))))))))

(define unload-resource
  (lambda (resource)
    (case (ftype-pointer->ftype-symbol resource)
      [(Texture Texture2D) (UnloadTexture resource)]
      [(Sound) (UnloadSound resource)]
      [(Music) (UnloadMusicStream resource)]
      [else (error 'unload-resource "Not a valid resource type" resource)])))

(define-syntax make-chapter-render
  (lambda (scripts)
    (syntax-case scripts (assets)
      [(_ (assets (name (diff path) ...) ...))
       (with-syntax ([((resource-ref ...) ...)
		      (map generate-temporaries (syntax->list #'((path ...) ...)))])
	 (with-syntax ([(resource-id ...) (datum->syntax #'assets (datum (resource-ref ... ...)))]
		       [(paths ...) (datum->syntax #'assets (datum (path ... ...)))])
	   #'(syntax-rules ()
	       [(_ direct ......)
		(let ([resource-id #f] ...)
		  (dynamic-wind
		    (lambda ()
		      (set! resource-id (load-resource paths)) ...)
		    (fluid-let-syntax ([name (syntax-rules (diff ...)
					       [(_ diff) resource-ref] ...)] ...)
		      (lambda ()
			(drawing-loop
			 [(void)] []
			 [direct ......]
			 [(void)])))
		    (lambda ()
		      (unload-resource resource-id) ...
		      (set! resource-id #f) ...)))])))])))

(define replica
  (lambda (file)
    (let* ([port (open-input-file file)]
	   [asset (read port)])
      (close-input-port port)
      (with-syntax ([asset-part (datum->syntax #'file asset)])
	(syntax-rules ()
	  [(_ cmd ...)
	   (with-fullscreen
	    "缘心饲契"
	      (fluid-let ([*screen-height* (GetScreenHeight)]
			  [*screen-width* (GetScreenWidth)]
			  [scene draw-location])
		(let-syntax ([render (make-chapter-render asset-part)])
		  (render
		   cmd ...))))])))))

(define main
  (lambda ()
    (let-syntax ([game (replica "../scripts/1.replica")])
      (game (scene (bedroom morning))
	    (scene (yuki smile))
	    ))))



