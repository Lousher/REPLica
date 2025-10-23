(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(import (chezscheme csv7))

(define *MANIFEST* #f)
(define *SCREEN-HEIGHT* #f)
(define *SCREEN-WIDTH* #f)
(define *ASSETS* (make-hashtable symbol-hash symbol=?))
(define *EXIT* #f)
(define *SCREEN-TEXTURE* #f)
(define *SCREEN-TEXTURE-DRAWER* #f)
(define *FONT-DATA* #f)
(define *FONT-SIZE* (make-ftype-pointer int (foreign-alloc (ftype-sizeof int))))
(define *CODEPOINTS-COUNT* (make-ftype-pointer int (foreign-alloc (ftype-sizeof int))))
(define state #f)

;; global shader
(define mask-on #f)
(define mask-off #f)
(define blur-on #f)
(define blur-off #f)
(define wakeup #f)

;; global camera
(define bedroom-zoom
  (lambda ()
    (let ([passed 0.0]
	  [camera (init-Camera2D)]
	  [left-bottom `(0.0 . ,(* *SCREEN-HEIGHT* 1.0))])
	(Camera2D-offset-set! camera left-bottom)
	(Camera2D-zoom-set! camera 2.0)
	(lambda (x)
	  (when (<= passed 250.0)
	    (set! passed (+ passed 0.5)))
	  (Camera2D-target-set! camera (cons passed (exact->inexact *SCREEN-HEIGHT*)))
	  camera))))

(define-record-type frame-persistent
  (fields
   (mutable music)
   (mutable scene)
   (mutable camera)
   (mutable effect))
  (protocol
   (lambda (make)
     (case-lambda
       [() (make #f #f #f #f)]
       [(m s c e) (make m s c e)]))))
(define-record-type frame-temporary
  (fields character text voice sound)
  (protocol
   (lambda (make)
     (case-lambda
       [() (make #f #f #f #f)]
       [(c t v s) (make c t v s)]))))
(define-record-type frame
  (fields persistent-part
	  (mutable temporary-part))
  (protocol
   (lambda (make)
     (case-lambda
       [() (make (make-frame-persistent) (make-frame-temporary))]
       [(per tem) (make per tem)]))))

(define-record-type camera-2d
  (fields offset target rotation zoom))
(define-record-type manifest
  (fields title directories entry state))

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
					(if res-pair (cadr res-pair) (error 'read-manifest "No such key in manifest" key))))]
	   [state-list (configs-ref ':state)])
      (set! state (make-record-type "state" state-list))
      (make-manifest
       (configs-ref ':title)
       (configs-ref ':directories)
       (configs-ref ':entry)
       (apply (record-constructor state) (make-list (length state-list) #f))))))
(define fullscreen-init
  (lambda (title)
    (let ([w (GetScreenWidth)]
	  [h (GetScreenHeight)]
	  [flags (logor FLAG_WINDOW_MAXIMIZED FLAG_WINDOW_MINIMIZED)])
      (SetConfigFlags flags)
      (SetTargetFPS 60)
      (InitWindow w h title)
      (InitAudioDevice)
      (TraceLog LOG_INFO "Fullscreen Inited"))))
(define fullscreen-deinit
  (lambda () (CloseAudioDevice) (CloseWindow) (TraceLog LOG_INFO "Fullscreen Deinited")))
(define init-shaders
  (lambda ()
    (let* ([progress 0.0]
	   [mask (LoadShader #f "../assets/glsl/mask.fs")]
	   [progress-ptr (foreign-alloc (ftype-sizeof float))]
	   [progress-loc (GetShaderLocation mask "progress")]
	   [progress-fptr (make-ftype-pointer float progress-ptr)])
      (set! mask-on
	    (lambda ()
	      (lambda (x)
	      (when (<= progress 1.0)
		(set! progress (+ progress 0.02)))
	      (ftype-set! float () progress-fptr (min progress 1.0))
	      (SetShaderValue mask progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	      mask)))
      (set! mask-off
	    (lambda ()
	      (lambda (x)
		(when (>= progress 0.0)
		  (set! progress (- progress 0.02)))
		(ftype-set! float () progress-fptr (min progress 1.0))
		(SetShaderValue mask progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
		mask))))
    (let* ([progress 0.0]
	   [wake (LoadShader #f "../assets/glsl/wakeup.fs")]
	   [progress-ptr (foreign-alloc (ftype-sizeof float))]
	   [progress-loc (GetShaderLocation wake "progress")]
	   [progress-fptr (make-ftype-pointer float progress-ptr)])
      (set! wakeup
	    (lambda ()
	    (lambda (x)
	      (when (<= progress 1.0)
		(set! progress (+ progress 0.01)))
	      (ftype-set! float () progress-fptr (min progress 1.0))
	      (SetShaderValue wake progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	      wake)))
      )))

(define with-fullscreen
  (lambda (start)
    (let ([title (manifest-title *MANIFEST*)])
      (dynamic-wind
	(lambda ()
	  (fullscreen-init title) (init-shaders))
	(lambda ()
	  (fluid-let ([*SCREEN-WIDTH* (GetScreenWidth)] [*SCREEN-HEIGHT* (GetScreenHeight)]
		      [*SCREEN-TEXTURE* (LoadRenderTexture (GetScreenWidth) (GetScreenHeight))]
		      [*SCREEN-TEXTURE-DRAWER* (let ([src-rec (make-Rectangle 0.0 0.0 (* (GetScreenWidth) 1.0) (* (GetScreenHeight) -1.0))]
							      [ori-vec (make-Vector2 0.0 0.0)])
							  (lambda () (DrawTextureRec
								      (RenderTexture-texture *SCREEN-TEXTURE*)
								      src-rec ori-vec WHITE)))]
		      [*FONT-DATA* (LoadFileData "../assets/font/Xiaolai-Regular.ttf" *FONT-SIZE*)])
	    (start)))
	(lambda ()
	  (fullscreen-deinit))))))
(define load-background
  (lambda (bg-path)
    (let ([img (LoadImage bg-path)])
      (ImageResize img *SCREEN-WIDTH* *SCREEN-HEIGHT*)
      (let ([tex (LoadTextureFromImage img)])
	(UnloadImage img)
	tex))))
(define shading
  (lambda (sh prev next)
    (let ([progress-ptr #f])
      (dynamic-wind
	(lambda ()
	  (TraceLog LOG_INFO "Shading Transition Start")
	  (set! progress-ptr (foreign-alloc (ftype-sizeof float))))
	(lambda ()
	  (let ([prev-tex-loc (GetShaderLocation sh "texture1")]
		[progress-loc (GetShaderLocation sh "progress")]
		[progress-fptr (make-ftype-pointer float progress-ptr)]
		[total 1.5] [prev-scene (frame-persistent-scene (frame-persistent-part prev))]
		[new-scene (frame-persistent-scene (frame-persistent-part next))])
	    (let loop ([passed 0.0])
	      (ftype-set! float () progress-fptr (/ passed total))
	      (BeginDrawing)
	      (ClearBackground BLACK)
	      (BeginShaderMode sh)
	      (when prev-scene
		(SetShaderValueTexture sh prev-tex-loc prev-scene))
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
(define update-music
  (lambda (music)
    (when music
      (if (IsMusicStreamPlaying music)
	  (UpdateMusicStream music)
	  (PlayMusicStream music)))))
(define draw-character
  (lambda (tex loc total)
    (when tex
      (let* ([w-seg (/ *SCREEN-WIDTH* total)]
	     [xpos (- (+ (/ w-seg 2.0) (* (1- loc) w-seg)) (/ (Texture-width tex) 2.0))]
	     [ypos (- (* *SCREEN-HEIGHT* 1.0) (Texture-height tex))])
	(DrawTextureV tex (make-Vector2 xpos ypos) WHITE)))))
(define wait-script?
  (lambda (script)
    (memv (car script) '(wait))))
(define next-script?
  (lambda (script)
    (memv (car script) '(next))))
(define normal-script?
  (lambda (script)
    (memv (car script) '(scene music text character voice sound camera effect))))
(define read-script
  (lambda (port)
    (let ([content (read port)])
      (cond
       [(eof-object? content) '()]
       [(wait-script? content) (list content)]
       [(next-script? content) (list content)]
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
	      [(:voice :sound) (hashtable-set! *ASSETS* key (LoadSound fullpath))]
	      [(:music) (hashtable-set! *ASSETS* key (LoadMusicStream fullpath))]
	      [else (error 'assets-cache "No such file in manifest defined directories" filename)])))))))
(define assets-ref
  (lambda (key)
    (hashtable-ref *ASSETS* key (lambda () (error 'assets-ref "No such key in assets" key)))))
(define symbol-concat
  (lambda syms
    (let ([all-str (apply format
			  (apply string-append (make-list (length syms) "~a-"))
			  syms)])
      (string->symbol (substring all-str 0 (1- (string-length all-str)))))))
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

(define asset-expression?
  (lambda (x)
    (and (list? x)
	 (= 2 (length x))
	 (for-all symbol?  x))))
(define script->frame
  (lambda (script)
    (let* ([frame-persistent-rtd (record-type-descriptor (make-frame-persistent))]
	   [frame-temporary-rtd (record-type-descriptor (make-frame-temporary))]
	   [frame-persistent-fields (record-type-field-names frame-persistent-rtd)]
	   [frame-temporary-fields (record-type-field-names frame-temporary-rtd)])
      (let ([script-persistent-part (map (lambda (per-f)
					   (let ([exist (assv per-f script)])
					     (cond
					      [(and exist (not (null? (cdr exist))))
					       (cdr exist)]
					      [else #f])))
					 frame-persistent-fields)]
	    [script-tempory-part (map (lambda (tem-f)
					(let ([exist (assv tem-f script)])
					  (if (and exist (not (null? (cdr exist))))
					      (cdr exist) #f)))
				      frame-temporary-fields)])
	(let ([script->arguments (lambda (sc)
				   (if sc (map (lambda (item)
						 (cond
						  [(asset-expression? item)
						   (assets-ref (apply symbol-concat item))]
						  [(list? item) (eval item)]
						  [else item])) sc)
				       #f))])
	  (make-frame
	   (apply make-frame-persistent (map script->arguments script-persistent-part))
	   (apply make-frame-temporary (map script->arguments script-tempory-part))))))))

(define make-frame-render
  (lambda (fr)
    (assert (frame? fr))
    (let ([per-part (frame-persistent-part fr)]
	  [tmp-part (frame-temporary-part fr)])
      (let ([scene-args (frame-persistent-scene per-part)]
	    [music-args (frame-persistent-music per-part)]
	    [camera-args (frame-persistent-camera per-part)]
	    [effect-args (frame-persistent-effect per-part)]
	    [character-args (frame-temporary-character tmp-part)]
	    [text-args (frame-temporary-text tmp-part)]
	    [voice-args (frame-temporary-voice tmp-part)]
	    [sound-args (frame-temporary-sound tmp-part)])
	(let ([camera-fn (if camera-args (car camera-args) #f)]
	      [effect-fn (if effect-args (car effect-args) #f)])
	  (let* ([texts (if text-args (cdr text-args) '(""))]
		 [codepoints (LoadCodepoints (apply string-append texts) *CODEPOINTS-COUNT*)]
		 [font (LoadFontFromMemory
			".ttf" *FONT-DATA* (ftype-ref int () *FONT-SIZE*)
			32 codepoints (ftype-ref int () *CODEPOINTS-COUNT*))]
		 [text-vec (make-Vector2 (* *SCREEN-WIDTH* 0.2) (* *SCREEN-HEIGHT* 0.7))])
	    (UnloadCodepoints codepoints)
	    (values
	     (lambda (passed)
	       (BeginTextureMode *SCREEN-TEXTURE*)
	       (when camera-args
		 (BeginMode2D (camera-fn passed)))
	       (when scene-args
		 (DrawTexture (car scene-args) 0 0 WHITE))
	       (EndMode2D)
	       (EndTextureMode)

	       (when effect-args
		 (BeginShaderMode (effect-fn passed)))
	       (*SCREEN-TEXTURE-DRAWER*)
	       (EndShaderMode)

	       (DrawTextEx
		font
		(TextSubtext (car texts) 0 (* 3 (floor (/ passed 5))))
		text-vec 50.0 0.0 WHITE))
	     (lambda ()
	       (when sound-args
		 (PlaySound (car sound-args)))))))))))

(define rendering
  (lambda (fr)
    (TraceLog LOG_INFO "Enter frame")
    (let-values ([(renderer sounder) (make-frame-render fr)])
      (sounder)
      (let loop ([passed 0])
	(when (WindowShouldClose)
	  (*EXIT*))
	(BeginDrawing)
	(ClearBackground BLACK)
	(renderer passed)
	(EndDrawing)
	(unless (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	  (loop (+ passed 1)))))
    (TraceLog LOG_INFO "Exit frame")
    fr))

(define completing
  (lambda (fr)
    (let ([fr-temp (frame-temporary-part fr)])
      (let ([so (frame-temporary-sound fr-temp)]
	    [va (frame-temporary-voice fr-temp)])
      (when (and so (IsSoundPlaying so))
	(StopSound so))
      (when (and va (IsSoundPlaying va))
	(StopSound va))))))

(define frame-succeed
  (lambda (prev next)
    (let* ([frame-persistent-rtd (record-type-descriptor (make-frame-persistent))]
	   [frame-persistent-fields (record-type-field-names frame-persistent-rtd)]
	   [frame-persistent-accessors (map (lambda (field) (record-field-accessor frame-persistent-rtd field)) frame-persistent-fields)]
	   [frame-persistent-mutators (map (lambda (field) (record-field-mutator frame-persistent-rtd field)) frame-persistent-fields)])
      (let ([next-persistent-part (frame-persistent-part next)]
	    [prev-persistent-part (frame-persistent-part prev)])
	(for-each (lambda (accessor mutator)
		    (let ([next-val (accessor next-persistent-part)])
		      (cond
		       [(and next-val (eqv? 'reset (car next-val)))
			(mutator prev-persistent-part #f)]
		       [next-val (mutator prev-persistent-part next-val)])
		      ))
		  frame-persistent-accessors frame-persistent-mutators)
	(frame-temporary-part-set! prev (frame-temporary-part next))
	prev))))
(define storying
  (lambda (chapter-file)
    (let*-values ([(assets scripts) (read-chapter chapter-file)]
		  [(load-assets unload-assets) (assets-lifecycle (assets-flatten assets))])
      (dynamic-wind
	(lambda () (load-assets))
	(lambda ()
	  (let ([frames (map script->frame scripts)]
		[fade (LoadShader #f "../assets/glsl/fade.fs")])
	    (fold-left
	     (lambda (prev next)
	       (let ([succeed (frame-succeed prev next)])
		 (rendering succeed)))
	     (make-frame)
	     frames)))
	(lambda () (unload-assets))))))

(define replica
  (lambda (manifest-file)
    (assert (file-exists? manifest-file))
    (fluid-let ([*MANIFEST* (read-manifest manifest-file)])
      (with-fullscreen
       (call/cc
	(lambda (exit)
	  (fluid-let ([*EXIT* exit])
	    (lambda ()
	      (storying (manifest-entry *MANIFEST*))))))))))
