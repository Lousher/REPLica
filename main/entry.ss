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
(define state #f)
					; 1 ~ 5 fields are able to succeed
(define-record-type frame
  (fields music scene camera effect character text voice sound))
(define-record-type camera-2d
  (fields offset target rotation zoom))
(define-record-type manifest
  (fields title directories entry state))
(define frame-succeed
  (lambda (prev next)
    (let ([frame-fields (record-type-field-names (record-type-descriptor prev))])
      (let* ([frame-rtd (record-type-descriptor prev)]
	     [frame-field-accessor (lambda (key) (record-field-accessor frame-rtd key))]
	     [frame-field-accessors (map frame-field-accessor frame-fields)]
	     [frame-vals (lambda (f) (map (lambda (acc) (acc f)) frame-field-accessors))])
	(let ([prev-vals (frame-vals prev)]
	      [next-vals (frame-vals next)])
	  (let ([combined-vals (map (lambda (prev-val next-val) (if next-val next-val prev-val))
				    prev-vals next-vals)])
	    (apply make-frame
		   (append (list-head combined-vals 6)
			   (list-tail next-vals 6)))))))))
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
(define with-fullscreen
  (lambda (start)
    (let ([title (manifest-title *MANIFEST*)])
      (dynamic-wind
	(lambda () (fullscreen-init title))
	(lambda () (fluid-let ([*SCREEN-WIDTH* (GetScreenWidth)] [*SCREEN-HEIGHT* (GetScreenHeight)]
			       [*SCREEN-TEXTURE* (LoadRenderTexture (GetScreenWidth) (GetScreenHeight))])
		     (start)))
	(lambda () (fullscreen-deinit))))))
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
		[total 1.5] [prev-scene (frame-scene prev)]
		[new-scene (frame-scene next)])
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
(define script->frame
  (lambda (script)
    (let ([scene-part (assv 'scene script)]
	  [music-part (assv 'music script)]
	  [character-part (assv 'character script)]
	  [text-part (assv 'text script)]
	  [camera-part (assv 'camera script)]
	  [voice-part (assv 'voice script)]
	  [sound-part (assv 'sound script)]
	  [effect-part (assv 'effect script)]
	  [resource-ref (lambda (part)
			  (if part (assets-ref (apply symbol-concat (cadr part))) #f))])
      (let ([music-resource (resource-ref music-part)]
	    [scene-resource (resource-ref scene-part)]
	    [character-resource (resource-ref character-part)]
	    [voice-resource (resource-ref voice-part)]
	    [sound-resource (resource-ref sound-part)])
	(make-frame
	 music-resource
	 scene-resource
	 (if camera-part (eval (cadr camera-part)) #f)
	 (if effect-part (eval (cadr effect-part)) #f)
	 character-resource
	 (if text-part (cdr text-part) #f)
	 voice-resource
	 sound-resource
	 )))))
(define drawing
  (lambda (fr)
    (let ([mu (frame-music fr)]
	  [sc (frame-scene fr)]
	  [ch (frame-character fr)]
	  [va (frame-voice fr)]
	  [so (frame-sound fr)]
	  [te-w (/ *SCREEN-WIDTH* 5.0)]
	  [te-h (* 2.0 (/ *SCREEN-HEIGHT* 3.0))]
	  [ca (frame-camera fr)]
	  [ve (frame-effect fr)])
      (let* ([te (if (frame-text fr) (cadr (frame-text fr)) "")]
	     [pos (make-Vector2 te-w te-h)]
	     [ct-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
	     [cts (LoadCodepoints te ct-count)]
	     [font (LoadFontEx "../assets/font/Xiaolai-Regular.ttf" 50 cts (ftype-ref int () ct-count))])
	(TraceLog LOG_INFO "Enter frame")
	(let ([drawer (lambda (passed)
			(update-music mu)
			(BeginTextureMode *SCREEN-TEXTURE*)
			(when ca
			  (BeginMode2D (ca passed)))
			(DrawTexture sc 0 0 WHITE)
			(EndMode2D)
			(EndTextureMode)
			(when ve
			  (BeginShaderMode (ve passed)))
			(DrawTextureRec (RenderTexture-texture *SCREEN-TEXTURE*)
					(make-Rectangle 0.0 0.0 (* *SCREEN-WIDTH* 1.0) (* *SCREEN-HEIGHT* -1.0))
					(make-Vector2 0.0 0.0)
					WHITE)
			(EndShaderMode)
			(draw-character ch 3 5)
			(DrawTextEx
			 font (TextSubtext te 0 (* 3 (floor (/ passed 3))))
			 pos 50.0 0.0 WHITE))])
	(when va (PlaySound va))
	(when so (PlaySound so))
	(let loop ([passed 0])
	  (when (WindowShouldClose)
	    (*EXIT*))
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (drawer passed)
	  (EndDrawing)
	  (unless (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (loop (+ passed 1)))))
	(TraceLog LOG_INFO "Exit frame")
	(foreign-free (ftype-pointer-address ct-count))
	(UnloadCodepoints cts)
	(UnloadFont font)
      fr))))
(define completing
  (lambda (fr)
    (let ([so (frame-sound fr)]
	  [va (frame-voice fr)])
      (when (and so (IsSoundPlaying so))
	(StopSound so))
      (when (and va (IsSoundPlaying va))
	(StopSound va)))))
(define replica-bak
  (lambda (manifest-file)
    (fluid-let ([*MANIFEST* (read-manifest manifest-file)])
      (call/cc
       (lambda (exit)
	 (fluid-let ([*EXIT* exit])
	   (with-fullscreen
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
			 (let ([updated (frame-succeed prev next)])
			   (completing prev)
			   (unless (equal? (frame-scene prev) (frame-scene updated))
			     (shading fade prev updated))
			   (drawing updated)))
		       (make-frame #f #f #f #f #f #f #f #f)
		       frames)))
		  (lambda () (unload-assets)))))))
	 )))))

(define replica
  (lambda (manifest-file)
    (assert (file-exists? manifest-file))
    (fluid-let ([*MANIFEST* (read-manifest manifest-file)])
      (with-fullscreen
       (call/cc
	(lambda (exit)
	  (fluid-let ([*EXIT* exit])
	    (lambda ()
	      (let next ([chapter (manifest-entry *MANIFEST*)])
		(let*-values ([(assets scripts) (read-chapter chapter)]
			      [(load-assets unload-assets) (assets-lifecycle (assets-flatten assets))])
		  (dynamic-wind
		    (lambda () (load-assets))
		    (lambda ()
		      (let ([frames (map script->frame scripts)]
			    [fade (LoadShader #f "../assets/glsl/fade.fs")])
			(fold-left
			 (lambda (prev next)
			   (let ([updated (frame-succeed prev next)])
			     (completing prev)
			     (unless (equal? (frame-scene prev) (frame-scene updated))
			       (shading fade prev updated))
			     (drawing updated)))
			 (make-frame #f #f #f #f #f #f #f #f)
			 frames)))
		    (lambda () (unload-assets)))
		  (let* ([last-script (car (last-pair scripts))]
			 [last-cmd (car (last-pair last-script))])
		    (when (next-script? last-cmd)
		      (next (cadr last-cmd))))))))))))))
