(load-shared-object "libraylib.5.5.0.dylib")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

(define *MANIFEST* #f)
(define *SCREEN-HEIGHT* #f)
(define *SCREEN-WIDTH* #f)
(define *PREVIOUS-SCREEN* #f)

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
  (lambda (gaming)
    (let ([title (manifest-title *MANIFEST*)])
      (dynamic-wind
	(lambda () (fullscreen-init title))
	(lambda () (fluid-let ([*SCREEN-WIDTH* (GetScreenWidth)] [*SCREEN-HEIGHT* (GetScreenHeight)]) (gaming)))
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
		[total 1.5])
	    (let loop ([passed 0.0])
	      (ftype-set! float () progress-fptr (/ passed total))
	      (BeginDrawing)
	      (ClearBackground BLACK)
	      (BeginShaderMode sh)
	      (SetShaderValueTexture sh prev-tex-loc *PREVIOUS-SCREEN*)
	      (SetShaderValue sh progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	      (DrawTexture next 0 0 WHITE)
	      (EndShaderMode)
	      (EndDrawing)
	      (when (<= passed total)
		(loop (+ passed (GetFrameTime)))))))
	(lambda ()
	  (foreign-free progress-ptr)
	  (TraceLog LOG_INFO "Shading Transition Over"))))))
  
(define drawing
  (lambda (frames)
    (let* ([fade (LoadShader #f "../assets/glsl/fade.fs")]
	   [index 0] [frame (vector-ref frames index)])
      (let loop ()
	(when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	  (fluid-let ([*PREVIOUS-SCREEN* frame])
	    (set! index (1+ index))
	    (set! frame (vector-ref frames index))
	    (shading fade frame)))
	(BeginDrawing)
	(ClearBackground BLACK)
	(DrawTexture frame 0 0 WHITE)
	(EndDrawing)
	(unless (WindowShouldClose)
	  (loop))))))

(define replica
  (lambda (manifest-file)
    (fluid-let ([*MANIFEST* (read-manifest manifest-file)])
      (with-fullscreen
       (lambda ()
	 (let ([bg1 (load-background "../assets/bg/yuwen.bedroom.morning.png")]
	       [bg2 (load-background "../assets/bg/yuwen.bedroom.afternoon.png")]
	       [bg3 (load-background "../assets/bg/yuwen.bedroom.night.png")]
	       [bg4 (load-background "../assets/bg/yuwen.bedroom.night.light.png")])
	   (let ([bg-vec (vector bg1 bg2 bg3 bg4)])
	      (drawing bg-vec))))))))

