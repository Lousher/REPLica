(library (loader)
  (export effect transition background sound resource-collect resource-guardian)
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
	  [(Texture Texture2D)
	   (UnloadTexture res)
	   (TraceLog LOG_INFO (format-green "Unload Texture Resurce ~a" res))]
	  [(Shader)
	   (UnloadShader res)
	   (TraceLog LOG_INFO (format-green "Unload Shader Resurce ~a" res))]
	  [(Sound)
	   (UnloadSound res)
	   (TraceLog LOG_INFO (format-green "Unload Sound Resurce ~a" res))]
	  [(Vector2 Vector Rectangle) (foreign-free (ftype-pointer-address res))
	   (TraceLog LOG_INFO (format-green "Unload Vector/Rectangle Resurce ~a" res))])]
       [else (TraceLog LOG_INFO (format-green "Unload Normal Resurce ~a" res))])))
  
  (define resource-collect
    (lambda ()
      (let loop ()
	(let ([res (resource-guardian)])
	  (when res
	    (TraceLog LOG_INFO (format-green "Begin Resource Collect"))
	    (resource-free res)
	    (loop))))))
  
  (define-syntax background
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let ([img (LoadImage path)])
	   (ImageResize img (GetScreenWidth) (GetScreenHeight))
	   (let ([tex (LoadTextureFromImage img)])
	     (UnloadImage img)
	     (resource-guardian tex)
	     tex)))]))

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
	 (let* ([sh (LoadShader vs fs)]
		[texture1-location (GetShaderLocation sh "texture1")]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)])
	   (resource-guardian sh)
	   (resource-guardian progress-fptr)
	   (lambda (ani duration)
	     (let ([started #f] [progress 0.0] [prev #f])
	       (lambda (s)
		 (unless started
		   (set! started (state-time s)))
		 (unless prev
		   (set! prev (state-previous s)))
		 (BeginShaderMode sh)
		 (when (< progress 1.0)
		   (set! progress (/ (- (state-time s) started) duration))
		   (SetShaderValueTexture sh texture1-location prev)
		   (ftype-set! float () progress-fptr progress)
		   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))
		 (ani s)
		 (EndShaderMode))
	       ))))]))

  (define-syntax effect
    (syntax-rules ()
      [(_ name vs fs)
       (define name
	 (let* ([sh (LoadShader vs fs)]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)])
	   (resource-guardian sh)
	   (resource-guardian progress-fptr)
	   (lambda (ani duration)
	     (let ([started #f] [progress 0.0])
	       (lambda (s)
		 (unless started
		   (set! started (state-time s)))
		 (BeginShaderMode sh)
		 (when (< progress 1.0)
		   (set! progress (/ (- (state-time s) started) duration))
		   (ftype-set! float () progress-fptr progress)
		   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))
		 (ani s)
		 (EndShaderMode))
	       ))))]))

    
  )
