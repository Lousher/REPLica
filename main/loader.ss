(library (loader)
  (export *text* phone dialogue effect transition sound resource-collect resource-guardian texture phone camera)
  (import (chezscheme)
	  (state)
	  (tool)
	  (raylib ffi)
	  (raylib constant))
  
  (define resource-guardian (make-guardian))
  
  (define resource-free
    (lambda (res)
      (cond
       [(ftype-pointer? res)
	(case (ftype-pointer->ftype-symbol res)
	  [(Font)
	   (UnloadFont res)
	   (TraceLog LOG_INFO (format-green "Unload Font Resurce ~a" res))]
	  [(Image)
	   (UnloadImage res)
	   (TraceLog LOG_INFO (format-green "Unload Image Resurce ~a" res))]
	  [(Texture Texture2D)
	   (UnloadTexture res)
	   (TraceLog LOG_INFO (format-green "Unload Texture Resurce ~a" res))]
	  [(Shader)
	   (UnloadShader res)
	   (TraceLog LOG_INFO (format-green "Unload Shader Resurce ~a" res))]
	  [(RenderTexture RenderTexture2D)
	   (UnloadRenderTexture res)
	   (TraceLog LOG_INFO (format-green "Unload RenderTexture Resurce ~a" res))
	   ]
	  [(Sound)
	   (UnloadSound res)
	   (TraceLog LOG_INFO (format-green "Unload Sound Resurce ~a" res))]
	  [(Vector2 Vector Rectangle)
	   (foreign-free (ftype-pointer-address res))
	   (TraceLog LOG_INFO (format-green "Unload Vector/Rectangle Resurce ~a" res))]
	  [(Camera Camera2D)
	   (foreign-free (ftype-pointer-address res))
	   (TraceLog LOG_INFO (format-green "Unload Camera2D Resurce ~a" res))
	   ])]
       [else
	(foreign-free res)
	(TraceLog LOG_INFO (format-green "Unload Normal Resurce ~a" res))])))
  
  (define resource-collect
    (lambda ()
      (let loop ()
	(let ([res (resource-guardian)])
	  (when res
	    (resource-free res)
	    (loop))))))

  (define load-texture-async
    (lambda (path)
      (let ([future (make-resource (make-mutex) 'loading #f)])
	(fork-thread
	 (lambda ()
	   (let ([img (LoadImage path)])
	     (resource-guardian img)
	     (with-mutex (resource-lock future)
	       (resource-data-set! future img)
	       (resource-status-set! future 'ram-ready))
	     (TraceLog LOG_INFO (format-green "Async: RAM loaded for ~a\n" path)))))
	future)))

  (define-syntax texture
    (syntax-rules ()
      [(_ name path)
       (define name (load-texture-async path))]))

  (define-syntax sound
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let ([so (LoadSound path)])
	   (resource-guardian so)
	   so))]))
  
  (define-syntax transition
    (syntax-rules ()
      [(_ name vs fs)
       (define name
	 (let* ([sh (LoadShader vs fs)] [rt #f]
		[origin (make-Vector2 0.0 0.0)]
		[src (make-Rectangle 0.0 0.0 0.0 0.0)]
		[texture1-location (GetShaderLocation sh "texture1")]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)])
	   (resource-guardian origin)
	   (resource-guardian src)
	   (resource-guardian sh)
	   (resource-guardian progress-fptr)
	   (lambda (ani duration)
	     (let ([started #f] [progress 0.0] [prev #f])
	       (lambda (s)
		 (unless started
		   (set! started (state-time s)))
		 (unless prev
		   (set! prev (state-previous s)))
		 (unless rt
		   (let ([win (state-window s)])
		     (set! rt (LoadRenderTexture (exact (window-width win)) (exact (window-height win))))
		     (Rectangle-width-set! src (inexact (window-width win)))
		     (Rectangle-height-set! src (* -1.0 (window-height win)))
		     (resource-guardian rt)))
		 (BeginTextureMode rt)
		 (ClearBackground BLANK)
		 (ani s)
		 (EndTextureMode)
		 (BeginShaderMode sh)
		 (when (< progress 1.0)
		   (set! progress (/ (- (state-time s) started) duration))
		   (SetShaderValueTexture sh texture1-location prev)
		   (ftype-set! float () progress-fptr progress)
		   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))
		 (DrawTextureRec (RenderTexture-texture rt) src origin WHITE)
		 (EndShaderMode))
	       ))))]))

  (define-syntax effect
    (syntax-rules ()
      [(_ name vs fs)
       (define name
	 (let* ([sh (LoadShader vs fs)] [rt #f]
		[origin (make-Vector2 0.0 0.0)]
		[src (make-Rectangle 0.0 0.0 0.0 0.0)]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)])
	   (resource-guardian origin)
	   (resource-guardian src)
	   (resource-guardian sh)
	   (resource-guardian progress-fptr)
	   (lambda (ani duration)
	     (let ([started #f] [progress 0.0])
	       (lambda (s)
		 (unless started
		   (set! started (state-time s)))
		 (unless rt
		   (let ([win (state-window s)])
		     (set! rt (LoadRenderTexture (exact (window-width win)) (exact (window-height win))))
		     (Rectangle-width-set! src (inexact (window-width win)))
		     (Rectangle-height-set! src (* -1.0 (window-height win)))
		     (resource-guardian rt)))
		 (BeginTextureMode rt)
		 (ClearBackground BLANK)
		 (ani s)
		 (EndTextureMode)
		 (BeginShaderMode sh)
		 (when (< progress 1.0)
		   (set! progress (/ (- (state-time s) started) duration))
		   (ftype-set! float () progress-fptr progress)
		   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))
		 (DrawTextureRec (RenderTexture-texture rt) src origin  WHITE)
		 (EndShaderMode))
	       ))))]))

  (define *text* (make-parameter #f))

  (define-syntax dialogue
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let* ([codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
		[codepoints (LoadCodepoints (*text*) codepoints-count)]
		[font (LoadFontEx path 50 codepoints (ftype-ref int () codepoints-count))]
		[sh (LoadShader #f "assets/glsl/outline.fs")]
		[color-location (GetShaderLocation sh "color")]
		[width-location (GetShaderLocation sh "width")]
		[width-ptr (foreign-alloc (ftype-sizeof float))]
		[color-ptr (foreign-alloc (* 4 (ftype-sizeof float)))])
	   (resource-guardian font)
	   (resource-guardian sh)
	   (UnloadCodepoints codepoints)
	   (foreign-free (ftype-pointer-address codepoints-count))

	   (foreign-set! 'float width-ptr 0 2.0)
	   (SetShaderValue sh width-location width-ptr SHADER_UNIFORM_FLOAT)
	   (foreign-set! 'float color-ptr 0 0.0)
	   (foreign-set! 'float color-ptr 4 0.0)
	   (foreign-set! 'float color-ptr 8 0.0)
	   (foreign-set! 'float color-ptr 12 1.0)
	   (SetShaderValue sh color-location color-ptr SHADER_UNIFORM_VEC4)
	   (foreign-free color-ptr)
	   (foreign-free width-ptr)
	   (lambda (text)
	     (let* ([position (make-Vector2 0.0 0.0)]
		    [origin (make-Vector2 0.0 0.0)]
		    [len (string-length text)]
		    [subtexts (map (lambda (index) (substring text 0 index)) (map (lambda (x) (+ x 1)) (iota len)))]
		    [measured-vecs (map (lambda (t) (MeasureTextEx font t 50.0 0.0)) subtexts)]
		    [origin-xs (map (lambda (v) (/ (Vector2-x v) 2.0)) measured-vecs)]
		    [origin-y (/ (Vector2-y (car measured-vecs)) 2.0)]
		    [started #f])
	       (Vector2-y-set! origin origin-y)
	       (resource-guardian position origin)
	       (lambda (s)
		 (unless started
		   (set! started (state-time s)))
		 (let* ([win (state-window s)]
			[win-width (window-width win)]
			[win-height (window-height win)])
		   (Vector2-x-set! position (* win-width 0.5))
		   (Vector2-y-set! position (* win-height 0.8)))
		 (BeginShaderMode sh)
		 (let* ([passed (- (state-time s) started)]
			[index (min (exact (round (/ passed 0.05))) (- len 1))]
			[sub (list-ref subtexts index)] [origin-x (list-ref origin-xs index)])
		   (Vector2-x-set! origin origin-x)
		   (DrawTextPro font sub position origin 0.0 50.0 0.0 WHITE))
		 (EndShaderMode))))
	   ))]))

  (define-syntax phone
    (syntax-rules ()
      [(_ name phone-w phone-h)
       (define name
	 (let* ([w (GetScreenWidth)]
		[h (GetScreenHeight)]
		[round-rec (make-Rectangle (- (/ w 2.0) (/ phone-w 2.0)) (- (/ h 2.0) (/ phone-h 2.0)) (inexact phone-w) (inexact phone-h))]
		[src #f])
	   (resource-guardian round-rec)
	   (lambda (res)
	     (let ([origin (make-Vector2 0.0 0.0)])
	       (resource-guardian origin)
	       (lambda (s)
	       (let ([current-status #f] [current-data #f])
		 (with-mutex (resource-lock res)
		   (set! current-status (resource-status res))
		   (when (or (eqv? current-status 'ram-ready)
			     (eqv? current-status 'gpu-ready))
		     (set! current-data (resource-data res))))
		 (case current-status
		   [(loading)
		    (DrawText "Loading ..." 0 0 20 WHITE)]
		   [(ram-ready)
		    (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...\n")
		    (let ([tex (LoadTextureFromImage current-data)])
		      (resource-guardian tex)
		      (with-mutex (resource-lock res)
			(resource-data-set! res tex)
			(resource-status-set! res 'gpu-ready)))]
		   [(gpu-ready)
		    (unless src
		      (set! src (make-Rectangle 0.0 0.0 (inexact (Texture-width current-data)) (inexact (Texture-height current-data))))
		      (resource-guardian src))
		    (DrawRectangleRounded round-rec 0.25 8 BLACK)
		    (DrawTexturePro current-data src round-rec origin 0.0 WHITE)
		    (DrawRectangleRoundedLinesEx round-rec 0.25 8 3.0 LIGHTGRAY)])))))))]))

  (define-syntax camera
    (syntax-rules ()
      [(_ name movment)
       (define name
	 (lambda (ani)
	   (let ([started #f]
		 [ca (init-Camera2D)])
	     (resource-guardian ca)
	     (lambda (s)
	       (unless started
		 (set! started (state-time s)))
	       (call-with-values
		   (lambda () (movment (- (state-time s) started)))
		 (lambda (off-x off-y tar-x tar-y ro zo)
		   (ftype-set! Camera2D (offset x) ca off-x)
                   (ftype-set! Camera2D (offset y) ca off-y)
                   (ftype-set! Camera2D (target x) ca tar-x)
                   (ftype-set! Camera2D (target y) ca tar-y)
                   (Camera2D-rotation-set! ca ro)
                   (Camera2D-zoom-set! ca zo)))
	       (BeginMode2D ca)
	       (ani s)
	       (EndMode2D)
	       ))))]))
  )
