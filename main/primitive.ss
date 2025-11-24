(library (primitive)
  (export preload static resource-collect resource-clear load-texture-from-screen play )
  
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (tool))

  (define-record-type visual
    (fields resource position scale rotation color))

  (define-record-type audio
    (fields resource volume pitch pan))

  (define resource-guardian (make-guardian))

  (define load-texture-from-screen
    (lambda ()
      (let ([screen-img (LoadImageFromScreen)])
	(ImageResize screen-img (GetScreenWidth) (GetScreenHeight))
	(ImageFlipVertical screen-img)
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
	    [else (TraceLog LOG_WARNING (format-red "Unknow Resource ~a id ~a" type res))]))]
       [else
	(TraceLog LOG_WARNING (format-red "Unknow Resource ~a" res))])))

  (define load-primitive
    (lambda (type args)
      (case type
	[(transition effect)
	 (let ([sh (apply LoadShader args)])
	   (resource-guardian sh)
	   sh)]
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
		
  (define-syntax preload
    (syntax-rules ()
      [(_ (type name . args) ...)
       (lambda (state)
	 (let* ([current-res (cdr (assv ':resources state))]
		[new-resources (fold-left
				(lambda (acc name-sym type-sym args-list)
				  (let ([obj (load-primitive type-sym args-list)])
				    (alist-update acc name-sym obj)))
				current-res
				'(name ...)
				'(type ...)
				(list `args ...))]
		[new-state (alist-update state ':resources new-resources)])
	   (values 'ok new-state)))]))

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
  	  
)

