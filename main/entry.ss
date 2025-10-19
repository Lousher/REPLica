(load-shared-object "libraylib.5.5.0.dylib")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

(define *MANIFEST* #f)
(define *SCREEN-HEIGHT* #f)
(define *SCREEN-WIDTH* #f)
(define *PREVIOUS-SCREEN* #f)
(define *ASSETS* (make-hashtable symbol-hash symbol=?))

(define-record-type frame
  (fields
   (mutable music)
   (mutable scene)))
(define-record-type manifest
  (fields title directories entry))

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
(define read-manifest
  (lambda (file)
    (let* ([content (call-with-input-file file read)]
	   [configs (parse-params (cdr content))]
	   [configs-ref (lambda (key) (let ([res-pair (assv key configs)])
					(if res-pair (cadr res-pair) (error 'read-manifest "No such key in manifest" key))))])
      (make-manifest
       (configs-ref ':title)
       (configs-ref ':directories)
       (configs-ref ':entry)))))
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
  (lambda (start)
    (let ([title (manifest-title *MANIFEST*)])
      (dynamic-wind
	(lambda () (fullscreen-init title))
	(lambda () (fluid-let ([*SCREEN-WIDTH* (GetScreenWidth)] [*SCREEN-HEIGHT* (GetScreenHeight)])
		     (start
		      (manifest-entry *MANIFEST*))))
	(lambda () (fullscreen-deinit))))))
(define load-background
  (lambda (bg-path)
    (let ([img (LoadImage bg-path)])
      (ImageResize img *SCREEN-WIDTH* *SCREEN-HEIGHT*)
      (let ([tex (LoadTextureFromImage img)])
	(UnloadImage img)
	tex))))
(define shading
  (lambda (sh next)
    (let ([progress-ptr #f])
      (dynamic-wind
	(lambda ()
	  (TraceLog LOG_INFO "Shading Transition Start")
	  (set! progress-ptr (foreign-alloc (ftype-sizeof float))))
	(lambda ()
	  (let ([prev-tex-loc (GetShaderLocation sh "texture1")]
		[progress-loc (GetShaderLocation sh "progress")]
		[progress-fptr (make-ftype-pointer float progress-ptr)]
		[total 1.5] [new-scene (frame-scene next)] [prev-scene (frame-scene *PREVIOUS-SCREEN*)]
		[music (frame-music next)])
	    (let loop ([passed 0.0])
	      (ftype-set! float () progress-fptr (/ passed total))
	      (BeginDrawing)
	      (UpdateMusicStream music)
	      (ClearBackground BLACK)
	      (BeginShaderMode sh)
	      (SetShaderValueTexture sh prev-tex-loc prev-scene)
	      (SetShaderValue sh progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	      (DrawTexture new-scene 0 0 WHITE)
	      (EndShaderMode)
	      (EndDrawing)
	      (unless (or (>= passed total)
			  (IsMouseButtonPressed MOUSE_BUTTON_LEFT))
		(loop (+ passed (GetFrameTime)))))))
	(lambda ()
	  (foreign-free progress-ptr)
	  (TraceLog LOG_INFO "Shading Transition Over"))))))
(define drawing
  (lambda (frames)
    (let* ([fade (LoadShader #f "../assets/glsl/fade.fs")]
	   [index 0] [frame (vector-ref frames index)]
	   [scene (frame-scene frame)]
	   [music (frame-music frame)])
      (when music
	(PlayMusicStream music))
      (let loop ()
	(when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	  (fluid-let ([*PREVIOUS-SCREEN* frame])
	    (set! index (1+ index))
	    (set! frame (vector-ref frames index))
	    (set! scene (frame-scene frame))
	    (shading fade frame)))
	(UpdateMusicStream music)
	(BeginDrawing)
	(ClearBackground BLACK)
	(DrawTexture scene 0 0 WHITE)
	(EndDrawing)
	(unless (WindowShouldClose)
	  (loop))))))
(define wait-script?
  (lambda (script)
    (eqv? 'wait (car script))))
(define normal-script?
  (lambda (script)
    (memv (car script) '(scene music text character))))
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
(define assets-cache
  (lambda (asset-pair)
    (let ([key (car asset-pair)]
	  [filename (cdr asset-pair)]
	  [directories (parse-params (manifest-directories *MANIFEST*))])
      (let ([file-exists-in-directory?
	     (lambda (dir-pair)
	       (let ([dir (cadr dir-pair)])
		 (file-exists? (string-append dir filename))))])
	(let ([existed-dir (find file-exists-in-directory? directories)])
	  (let* ([path (cadr existed-dir)]
		 [fullpath (string-append path filename)])
	    (case (car existed-dir)
	      [(:background) (hashtable-set! *ASSETS* key (load-background fullpath))]
	      [(:characters) (hashtable-set! *ASSETS* key (LoadTexture fullpath))]
	      [(:voice) (hashtable-set! *ASSETS* key (LoadSound fullpath))]
	      [(:music) (hashtable-set! *ASSETS* key (LoadMusicStream fullpath))]
	      [else (error 'assets-cache "No such file in manifest defined directories" filename)])))))))
(define assets-ref
  (lambda (key)
    (hashtable-ref *ASSETS* key (lambda () (error 'assets-ref "No such key in assets" key)))))
(define unload-resource
  (lambda (resource)
    (case (ftype-pointer->ftype-symbol resource)
      [(Texture Texture2D) (UnloadTexture resource)]
      [(Sound) (UnloadSound resource)]
      [(Music) (UnloadMusicStream resource)]
      [else (error 'unload-resource "Not a valid resource type" resource)])))
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
(define assets-delete
  (lambda (key)
    (when (hashtable-contains? *ASSETS* key)
      (unload-resource (assets-ref key))
      (hashtable-delete! *ASSETS* key))))
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
    
(define replica
  (lambda (manifest-file)
    (fluid-let ([*MANIFEST* (read-manifest manifest-file)])
      (with-fullscreen
       (lambda (chapter-file)
	 (let*-values ([(assets scripts) (read-chapter chapter-file)]
		       [(load-assets unload-assets) (assets-lifecycle (assets-flatten assets))])
	   (dynamic-wind
	     (lambda () (load-assets))
	     (lambda ()
	       (let ([bg1 (load-background "../assets/bg/yuwen.bedroom.morning.png")]
		     [bg2 (load-background "../assets/bg/yuwen.bedroom.afternoon.png")]
		     [bg3 (load-background "../assets/bg/yuwen.bedroom.night.png")]
		     [bg4 (load-background "../assets/bg/yuwen.bedroom.night.light.png")]
		     [bgm (LoadMusicStream "../assets/bgm/midnight-trip.mp3")])
		 (let ([frames (vector-map (lambda (bg) (make-frame bgm bg)) (vector bg1 bg2 bg3 bg4))])
		   (drawing frames))))
	     (lambda () (unload-assets))
	     )))))))
