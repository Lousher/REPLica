(library (primitive)
  (export preload static resource-collect resource-clear load-texture-from-screen
	  play with-transition *story-text* with-font with-effect  stop lock)
  
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (tool))

  (define *story-text* (make-parameter ""))
  
  (define-record-type context
    (fields resource type properties))

  (define-record-type visual
    (fields resource position size rotation color))

  (define-record-type audio
    (fields resource volume pitch pan))

  (define resource-guardian (make-guardian))

  (define load-primitive
    (lambda (type args)
      (case type
	[(font)
	 (let* ([codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
		[codepoints (LoadCodepoints (*story-text*) codepoints-count)]
		[font (LoadFontEx (car args) 50 codepoints (ftype-ref int () codepoints-count))])
	   (UnloadCodepoints codepoints)
	   (foreign-free (ftype-pointer-address codepoints-count))
	   (make-context font 'font `((:size . 50) (:color . ,WHITE) (:speed . 0.1) (:position . (0 . 0)))))]
	[(effect)
	 (let* ([sh (apply LoadShader args)]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-setter (lambda (p)
				   (ftype-set! float () progress-fptr p)
				   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))])
	   (resource-guardian sh progress-fptr)
	   (make-context sh 'shader `((:setters . ((:progress . ,progress-setter))))))]
	[(transition)
	 (let* ([sh (apply LoadShader args)]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)]
		[texture1-location (GetShaderLocation sh "texture1")]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-setter (lambda (p)
				   (ftype-set! float () progress-fptr p)
				   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))]
		[previous-setter (lambda (tex)
				   (SetShaderValueTexture sh texture1-location tex))])
	   (resource-guardian sh progress-fptr)
	   (make-context sh 'shader `((:setters . ((:texture1 . ,previous-setter) (:progress . ,progress-setter))))))]
	[(sound)
	 (let ([so (apply LoadSound args)])
	   (resource-guardian so)
	   (make-audio so 1.0 1.0 0.5))]
	[(background)
	 (let ([img (apply LoadImage args)])
	   (ImageResize img (GetScreenWidth) (GetScreenHeight))
	   (let ([tex (LoadTextureFromImage img)])
	     (resource-guardian tex)
	     (UnloadImage img)
	     (make-visual tex '(0 . 0) 1.0 0.0 WHITE)))])))

  (define with-font
    (lambda (font-id text)
	(let ([cached #f] [speed #f] [color #f] [size #f]
	      [position #f])
	  (lambda (passed)
	    (lambda (state)
	      (unless cached
		(let* ([ctx (resource-ref state font-id)]
		       [props (context-properties ctx)])
		  (set! size (cdr (assv ':size props)))
		  (set! color (cdr (assv ':color props)))
		  (set! speed (cdr (assv ':speed props)))
		  (let* ([pos (cdr (assv ':position props))]
			 [pos-vec (make-Vector2 (inexact (car pos)) (inexact (cdr pos)))])
		    (resource-guardian pos-vec)
		    (set! position pos-vec))
		  (set! cached (context-resource ctx))))
	      (DrawTextEx cached text position (inexact size) 0.0 color))))))

  (define with-effect
    (lambda (tran-id anim duration)
      (let ([cached #f] [progress-setter #f])
	(lambda (passed)
	  (lambda (state)
	    (unless cached
	      (let* ([ctx (resource-ref state tran-id)]
		     [setters (assv ':setters (context-properties ctx))])
		(set! cached (context-resource ctx))
		(set! progress-setter (cdr (assv ':progress (cdr setters))))))
	    (BeginShaderMode cached)
	    (let ([progress (/ passed duration)])
	      (when (< progress 1.0)
		(progress-setter progress))
	      ((anim passed) state)
	      (EndShaderMode)))))))
	  
  (define with-transition
    (lambda (tran-id anim duration)
      (let ([cached #f] [progress-setter #f] [texture1-setter #f] [previous #f])
	(lambda (passed)
	  (lambda (state)
	    (unless cached
	      (let* ([ctx (resource-ref state tran-id)]
		     [setters (assv ':setters (context-properties ctx))])
		(set! cached (context-resource ctx))
		(set! progress-setter (cdr (assv ':progress (cdr setters))))
		(set! texture1-setter (cdr (assv ':texture1 (cdr setters))))
		(set! previous (cdr (assv ':previous state)))))
	    (BeginShaderMode cached)
	    (let ([progress (/ passed duration)])
	      (when (< progress 1.0)
		(progress-setter progress)
		(texture1-setter previous))
	      ((anim passed) state)
	      (EndShaderMode)))))))
  
  (define load-texture-from-screen
    (lambda ()
      (let ([screen-img (LoadImageFromScreen)])
	(ImageResize screen-img (GetScreenWidth) (GetScreenHeight))
;	(ImageFlipVertical screen-img)
	(let ([screen-tex (LoadTextureFromImage screen-img)])
	  (UnloadImage screen-img)
	  (resource-guardian screen-tex)
	  screen-tex))))

  (define resource-collect
    (lambda ()
      (let loop ()
	(let ([res (resource-guardian)])
	  (when res
	    (resource-free res)
	    (loop))))))

  (define resource-free
    (lambda (res)
      (cond
       [(ftype-pointer? res)
	(let ([type (ftype-pointer->ftype-symbol res)])
	  (case type
	    [(Texture Texture2D) (UnloadTexture res) (TraceLog LOG_INFO (format-green "Unloading Resource ~a id ~a." type res))]
	    [(Sound) (UnloadSound res) (TraceLog LOG_INFO (format-green "Unloading Resource ~a id ~a." type res))]
	    [(Music) (UnloadMusicStream res) (TraceLog LOG_INFO (format-green "Unloading Resource ~a id ~a." type res))]
	    [(Shader) (UnloadShader res) (TraceLog LOG_INFO (format-green "Unloading Resource ~a id ~a." type res))]
	    [(Font) (UnloadFont res) (TraceLog LOG_INFO (format-green "Unloading Resource ~a id ~a." type res))]
	    [else
	     (foreign-free (ftype-pointer-address res))
	     (TraceLog LOG_WARNING (format-red "Unknow Resource ~a id ~a" type res))]))]
       [else
	(TraceLog LOG_WARNING (format-red "Unknow Resource ~a" res))])))
  		
  (define-syntax preload
    (syntax-rules ()
      [(_ (type name . args) ...)
       (begin
	 (lambda (state)
	   (let* ([current-res (cdr (assv ':resources state))]
		  [new-resources (fold-left
				  (lambda (acc name-sym type-sym args-list)
				    (let ([obj (load-primitive type-sym args-list)])
				      (alist-update acc name-sym obj)))
				  current-res
				  '(name ...) '(type ...) (list `args ...))]
		  [new-state (alist-update state ':resources new-resources)])
	     (values 'ok new-state))))]))

  (define make-locked-action
    (lambda (animator)
      (lambda (state)
	(let animating ([passed 0.0])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  ((animator passed) state)
	  (EndDrawing)
	  (animating (+ (GetFrameTime) passed))))))

  (define lock
    (lambda (z-index animator)
      (lambda (state)
	(let ([layers (cdr (assv ':layers state))])
	  (values 'ok (alist-update state ':layers (alist-update layers z-index (make-locked-action animator))))))))

  (define resource-clear
    (lambda ()
      (lambda (state)
	(TraceLog LOG_INFO (format-green "State is ~a" state))
	(values 'ok (alist-update state ':resources '())))))

  (define resource-ref
    (lambda (state id)
      (let* ([ress (cdr (assv ':resources state))]
	     [res (cdr (assv id ress))])
	res)))

  (define static
    (lambda (res-id)
      (let ([res #f])
	(lambda (passed)
	  (lambda (state)
	    (unless res (set! res (resource-ref state res-id)))
	    (DrawTexture (visual-resource res) 0 0 (visual-color res)))))))

  (define play
    (lambda (res-id)
      (let ([played #f] [res #f])
	(lambda (passed)
	  (lambda (state)
	    (unless res
	      (set! res (resource-ref state res-id)))
	    (unless played
	      (PlaySound (audio-resource res))
	      (set! played #t)))))))

  (define stop
    (lambda (res-id)
      (let ([stoped #f] [res #f])
	(lambda (passed)
	  (lambda (state)
	    (unless res
	      (set! res (resource-ref state res-id)))
	    (unless stoped
	      (StopSound (audio-resource res))
	      (set! stoped #t)))))))

)
