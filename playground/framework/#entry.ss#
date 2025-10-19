					; -- loads part ---
(load-shared-object "libraylib.5.5.0.dylib")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

					; -- tools part --
(define :id? (lambda (id) (and (symbol? id) (char=? #\: (string-ref (symbol->string id) 0)))))
(define parse-params
  (lambda (params)
    (fold-left
     (lambda (acc next)
       (if (:id? next)
	   (append acc (list (list next)))
	   (let ([last (last-pair acc)])
	     (set-cdr! (car last) (append (cdar last) (list next)))
	     acc)))
     '()
     params)))

					; -- global variable --
(define *screen-width* #f)
(define *screen-height* #f)
(define *manifest* #f)
(define *frame-events* #f)
(define *assets* (make-hashtable symbol-hash symbol=?))

					; -- main part --
; mainly changed part
(define-record-type frame
  (fields
   (mutable scene)
   (mutable characters)
   (mutable text)
   (mutable music)
   (mutable wait)))

(define-record-type manifest
  (fields
   title entry background characters voice music))

(define-record-type event
  (fields predicate handler))

;different state with different events, different events leads to different state
(define-record-type state
  (fields
   (mutable type)
   (mutable frame)
   (mutable events)))

(define read-manifest
  (lambda (manifest)
    (let ([content (call-with-input-file manifest read)])
      (assert (eqv? 'manifest (car content)))
      (let* ([configs (parse-params (cdr content))]
	     [config-ref (lambda (key)
			   (let ([res (assv key configs)])
			     (if res (symbol->string (cadr res))
				 (error 'read-manifest "No such field in manifest" key))))])
	(make-manifest
	 (config-ref ':title)
	 (config-ref ':entry)
	 (config-ref ':background)
	 (config-ref ':characters)
	 (config-ref ':voice)
	 (config-ref ':music))))))

(define wait-script?
  (lambda (script)
    (eqv? 'wait (car script))))

(define normal-script?
  (lambda (script)
    (let ([key (car script)])
      (memv key '(scene character music text)))))

(define read-script
  (lambda (port)
    (let ([content (read port)])
      (cond
       [(eof-object? content) '()]
       [(wait-script? content) (list content)]
       [(normal-script? content) (cons content (read-script port))]
       [else (error 'read-script "Not a valid script" content)]))))

(define read-scripts
  (lambda (port)
    (let col ([scripts '()] [script (read-script port)])
      (if (null? script) (reverse scripts)
	  (col (cons script scripts) (read-script port))))))

(define read-chapter
  (lambda (chapter-file)
    (call-with-input-file chapter-file
      (lambda (port)
	(let* ([assets (read port)]
	       [scripts (read-scripts port)])
	  (assert (eqv? 'assets (car assets)))
	  (values assets scripts))))))

(define fullscreen-init
  (lambda (title)
    (let ([w (GetScreenWidth)]
	  [h (GetScreenHeight)]
	  [flags (logor FLAG_WINDOW_MAXIMIZED
			FLAG_WINDOW_MINIMIZED
			FLAG_WINDOW_RESIZABLE)])
      (SetConfigFlags flags)
      (SetTargetFPS 60)
      (InitWindow w h title)
      (InitAudioDevice))))

(define fullscreen-deinit
  (lambda () (CloseAudioDevice) (CloseWindow)))

(define with-fullscreen
  (lambda (title drawing)
    (assert (procedure? drawing))
    (dynamic-wind
      (lambda () (fullscreen-init title))
      (lambda ()
	(fluid-let ([*screen-width* (GetScreenWidth)]
		    [*screen-height* (GetScreenHeight)])
	(drawing)))
      (lambda () (fullscreen-deinit)))))

(define handle-events
  (lambda (state events)
    (fold-left (lambda (st event)
		 (let ([predicate (event-predicate event)]
		       [handler (event-handler event)])
		   (if (predicate st) (handler st) st)))
	       state events)))

(define drawing-loop
  (lambda (init-state)
    (let loop ([state init-state])
      (let* ([events (state-events state)]
	     [frame (state-frame state)]
	     [drawer (frame-drawer frame)])
	(let ([new-state (handle-events state events)])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (drawer)
	  (EndDrawing)
	  (unless (WindowShouldClose)
	    (loop new-state)))))))

(define frame-drawer
  (lambda (frame)
    (let* ([scene (frame-scene frame)])
      (scene-drawer scene))))

(define scene-drawer
  (let ([origin (make-Vector2 0.0 0.0)])
    (lambda (scene)
      (let* ([scene-width (Texture-width scene)] [scene-height (Texture-height scene)]
	     [src-rec (make-Rectangle 0.0 0.0 (exact->inexact scene-width) (exact->inexact scene-height))]
	     [dst-rec (make-Rectangle 0.0 0.0 (exact->inexact *screen-width*) (exact->inexact *screen-height*))])
	(lambda ()
	  (DrawTexturePro scene src-rec dst-rec origin 0.0 WHITE))))))

(define assets-flatten
  (lambda (assets)
    (syntax-case (datum->syntax #'assets-flatten assets) ()
      [(_ (name (diff path) ...) ...)
       (with-syntax ([(count ...) (datum->syntax #'assets-flatten (map length (syntax->datum #'((diff ...) ...))))])
	 (let* ([names (datum (name ...))] [counts (datum (count ...))]
		[name-mul-count (map (lambda (n c) (make-list c n)) names counts)])
	   (with-syntax ([((name-c ...) ...) (datum->syntax #'assets-flatten name-mul-count)])
	     (let* ([name-cs (datum (name-c ... ...))] [diff-s (datum (diff ... ...))]
		    [name-full (map (lambda (n d) (string->symbol (format "~a-~a" (symbol->string n) (symbol->string d)))) name-cs diff-s)])
	       (with-syntax ([(name-fulls ...) (datum->syntax #'assets-flatten name-full)]
			     [(paths ...) (datum->syntax #'assets-flatten (datum (path ... ...)))])
		 (syntax->datum
		  #'((name-fulls . paths) ...)))))))])))

(define assets-cache-background
  (lambda (key bg-path)
    (let ([img (LoadImage bg-path)])
      (ImageResize img *screen-width* *screen-height*)
      (let ([tex (LoadTextureFromImage img)])
	(UnloadImage img)
	(hashtable-set! *assets* key tex)))))

(define assets-cache-character
  (lambda (key path)
    (let ([tex (LoadTexture path)])
      (hashtable-set! *assets* key tex))))

(define assets-cache-voice
  (lambda (key path)
    (let ([so (LoadSound path)])
      (hashtable-set! *assets* key so))))

(define assets-cache-music
  (lambda (key path)
    (let ([mu (LoadMusicStream path)])
      (hashtable-set! *assets* key mu))))

(define assets-cache
  (lambda (asset-pair)
    (let ([key (car asset-pair)]
	  [filename (cdr asset-pair)])
      (let ([file-exist-in-path? (lambda (p)
				   (let ([full (string-append p filename)])
				     (if (file-exists? full) full #f)))])
	(cond
	 [(file-exist-in-path? (manifest-background *manifest*)) => (lambda (p) (assets-cache-background key p))]
	 [(file-exist-in-path? (manifest-characters *manifest*)) => (lambda (p) (assets-cache-character key p))]
	 [(file-exist-in-path? (manifest-voice *manifest*)) => (lambda (p) (assets-cache-voice key p))]
	 [(file-exist-in-path? (manifest-music *manifest*)) => (lambda (p) (assets-cache-music key p))]
	 [else (error 'assets-cache "Can not find resources with filename" filename)])))))

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

(define assets-delete
  (lambda (key)
    (when (hashtable-contains? *assets* key)
      (unload-resource (assets-ref key))
      (hashtable-delete! *assets* key))))
(define assets-ref
  (lambda (key)
    (hashtable-ref *assets* key (lambda () (error 'assets-ref "No such key in assets" key)))))
(define assets-lifecycle
  (lambda (asset-alist)
    (values
     (lambda ()
       (for-each
	assets-cache
	asset-alist))
     (lambda ()
       (let ([keys (map car asset-alist)])
	 (for-each assets-delete keys))))))

(define with-chapter
  (lambda (chapter-file render)
    (lambda ()
      (let*-values ([(assets scripts) (read-chapter chapter-file)]
		    [(load-assets unload-assets) (assets-lifecycle (assets-flatten assets))])
	(dynamic-wind
	  (lambda () (load-assets))
	  (lambda ()
	    (fluid-let ([*frame-events* (script->event scripts)])
	      (render)))
	  (lambda () (unload-assets)))))))

(define symbol-concat
  (lambda (a b)
    (string->symbol
     (format
      "~a-~a"
      (symbol->string a)
      (symbol->string b)))))

(define script->event
  (lambda (script)
    (let ([single-ref (lambda (key) (assv key script))]
	  [multiple-ref (lambda (key) (filter (lambda (x) (eqv? key (car x))) script))])
      (let ([music (single-ref 'music)]
	    [scene (single-ref 'scene)]
	    [chs (multiple-ref 'character)]
	    [wait (single-ref 'wait)]
	    [text (single-ref 'text)])
    (make-event
     (lambda (st)
       (and (eqv? 'game (state-type st))
	    (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))
     (lambda (st)
       (let ([frame (state-frame st)]
	     [ref-res (lambda (li) (assets-ref (symbol-concat (car li) (cadr li))))])
	 (when music
	   (frame-music-set! frame (ref-res (cadr music))))
	 (when scene
	   (frame-scene-set! frame (ref-res (cadr scene))))
	 st)))))))

(define replica
  (lambda (manifest-file)
    (fluid-let ([*manifest* (read-manifest manifest-file)])
      (with-fullscreen
       (manifest-title *manifest*)
       (with-chapter
	(manifest-entry *manifest*)
	  (lambda ()
	    (let* ([init-frame (make-frame
			  (make-ftype-pointer Texture (foreign-alloc (ftype-sizeof Texture)))
			  #f #f #f #f)]
		   [init-state (make-state 'game init-frame )])
	(drawing-loop init-state))))
       ))))
