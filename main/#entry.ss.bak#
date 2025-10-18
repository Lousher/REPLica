(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "syntax.ss")
(load "tools.ss")

(define DIALOG_ALPHA 0.4)
(define FILE_ALLTEXT "../scripts/allchars.txt")
(define REPLICA_FILE_SUFFIX "rpl")
(define REPLICA_MANIFEST_SUFFIX "rpcm")

(define FILE_FONT "../assets/font/Xiaolai-Regular.ttf")
(define TEXT_SHOWN 0)

(define *script-files* #f)
(define *screen-width* #f)
(define *screen-height* #f)
(define BACKGROUND-DIRECTORY #F)
(define CHARACTERS-DIRECTORY #f)
(define VOICE-DIRECTORY #f)
(define MUSIC-DIRECTORY #f)
(define scene #f)
(define character #f)
(define music #f)
(define done #f)

(define-record-type frame
  (fields
   (immutable scene)
   (immutable characters)
   (immutable text)
   (immutable music)
   (immutable wait)))

(define draw-location
  (let ([origin (make-Vector2 0.0 0.0)])
    (lambda (tex)
      (let ([tex-w (Texture-width tex)]
	    [tex-h (Texture-height tex)])
	(let ([src-rec (make-Rectangle 0.0 0.0 (exact->inexact tex-w) (exact->inexact tex-h))]
	      [dst-rec (make-Rectangle 0.0 0.0 (exact->inexact *screen-width*) (exact->inexact *screen-height*))])
	  (DrawTexturePro tex src-rec dst-rec origin 0.0 WHITE))))))

(define draw-characters
  (lambda (tex loc total)
    (let* ([w-seg (/ *screen-width* total)]
	   [xpos (- (+ (/ w-seg 2.0) (* (1- loc) w-seg)) (/ (Texture-width tex) 2.0))]
	   [ypos (- (* *screen-height* 1.0) (Texture-height tex))]
	   [ypos-mov (+ ypos (* (sin (* (GetTime) 1.5)) 3.0))])
      (DrawTextureV tex (make-Vector2 xpos ypos-mov) WHITE))))

#|(define draw-text
(lambda (who saying)
(let ([img (LoadImage "../assets/dialog/e.jpg")])
(ImageResize img w (round (/ h 3)))
(let ([tex (LoadTextureFromImage img)])
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
(lambda (who text)
(DrawTextureRec (RenderTexture-texture rt) rect vec (Fade WHITE DIALOG_ALPHA))
(DrawTextEx font who name-vec 75.0 0.0 color)
(DrawTextEx font (TextSubtext text 0 (* 3 (floor (/ TEXT_SHOWN 10)))) text-vec size 0.0 color)) |#

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
  (lambda (mus)
    (if (IsMusicStreamPlaying mus)
	(UpdateMusicStream mus)
	(PlayMusicStream mus))))

(define string-prefix?
  (lambda (pre str)
    (let ([len (string-length pre)])
      (string=? pre (substring str 0 len)))))

(define load-resource
  (lambda (path)
    (let ([suffix (file-suffix path)])
      (case suffix
	[("png" "jpg")
	 (let ([img (LoadImage path)])
	   (when (string-prefix? BACKGROUND-DIRECTORY path)
	     (ImageResize img *screen-width* *screen-height*))
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

(define render-init
  (lambda (scripts)
    (assert (eqv? 'assets (car scripts)))
    (let ([resources (cdr scripts)])
      (with-syntax ([((name (diff path) ...) ...) (datum->syntax #'f resources)])
	(with-syntax ([((resource-ref ...) ...)
		       (map generate-temporaries (syntax->list #'((path ...) ...)))])
	  (with-syntax ([(resource-id ...) (datum->syntax #'assets (datum (resource-ref ... ...)))]
			[(paths ...) (datum->syntax #'assets (datum (path ... ...)))])
	    (syntax-rules () 
	      [(_ . direct)
	       (let ([resource-id #f] ...)
		 (dynamic-wind
		   (lambda ()
		     (let* ([full-paths (map (lambda (dir) (string-append dir paths)) (list BACKGROUND-DIRECTORY CHARACTERS-DIRECTORY VOICE-DIRECTORY MUSIC-DIRECTORY))]
			    [exist-path (find file-exists? full-paths)])
		       (set! resource-id (load-resource exist-path))) ...)
		   (lambda ()
		     (fluid-let-syntax
			 ([name (syntax-rules (diff ...) [(_ diff) resource-ref] ...)] ...)
		       direct))
		   (lambda ()
		     (unload-resource resource-id) ...
		     (set! resource-id #f) ...)))])))))))

(define read-scripts
  (lambda (port)
    (let col ([scripts '()] [script (read-script port)])
      (if (null? script) (reverse scripts)
	  (col (cons script scripts) (read-script port))))))

(define read-script
  (lambda (port)
    (let ([content (read port)])
      (cond
       [(eof-object? content) '()]
       [(wait-command? content) (list content)]
       [else (cons content (read-script port))]))))

(define wait-command?
  (lambda (cmd) (eqv? 'wait (car cmd))))

(define script->frame
  (lambda (ss)
    (let ([scene (assv 'scene ss)]
	  [characters (filter (lambda (x) (eqv? (car x) 'character)) ss)]
	  [music (assv 'music ss)]
	  [text (assv 'text ss)]
	  [wait (assv 'wait ss)])
      (make-frame scene characters text music wait))))

(define draw-frame
  (lambda (frame)
    (let ([scene (frame-scene frame)]
	  [characters (frame-characters frame-characters)]
	  [music (frame-music frame)]
	  [text (frame-text frane)])
      #f)))

(define frame-drawer
  (lambda (frame)
    (let ([scene-part (frame-scene frame)]
	  [characters-part (frame-characters frame)]
	  [music-part (frame-music frame)])
      (lambda (stx)
	(syntax-case stx ()
	  [(k)
	   (with-syntax ([sc (datum->syntax #'k scene-part)]
			 [(chs ...) (datum->syntax #'k characters-part)]
			 [mu (datum->syntax #'k music-part)])
	     #'(begin
		 mu
		 sc
		 chs ...)
	     )])))))

(define replica
  (lambda (manifest-file)
    (assert (string=? REPLICA_MANIFEST_SUFFIX (file-suffix manifest-file)))
    (let* ([manifest (call-with-input-file manifest-file read)]
	   [configs (parse-params (cdr manifest))]
	   [title (symbol->string (cadr (assoc ':title configs)))]
	   [entry-file-name (symbol->string (cadr (assoc ':entry configs)))])
      (set! BACKGROUND-DIRECTORY (cadr (assoc ':background configs)))
      (set! CHARACTERS-DIRECTORY (cadr (assoc ':characters configs)))
      (set! VOICE-DIRECTORY (cadr (assoc ':voice configs)))
      (set! MUSIC-DIRECTORY (cadr (assoc ':music configs)))
      (let*-values ([(entry-asset entry-scripts)
		     (call-with-input-file entry-file-name
		       (lambda (p) (let* ([a (read p)] [s (read-scripts p)]) (values a s))))])
	(with-syntax ([as (datum->syntax #'replica entry-asset)]
		      [ti (datum->syntax #'replica title)]
		      [(ss ...) (datum->syntax #'replica (map script->frame entry-scripts))])
	  (syntax-rules ()
	    [(_)
	     (let-syntax ([game-ctx (with-fullscreen ti)]
			  [render-ctx (render-init 'as)]
			  [draw-frame (frame-drawer (car '(ss ...)))])
	       (game-ctx
		(render-ctx 
		 (fluid-let ([scene draw-location]
			     [character draw-characters]
			     [music play-music])
		   (drawing-loop
		    (WindowShouldClose)
		    [(void)]
		    [(draw-frame)])
		   ))))]))))))

(define-syntax karma*feed (replica "../scripts/manifest.rpcm"))
