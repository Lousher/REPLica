(library (primitive)
  (export preload static resource-collect resource-clear load-texture-from-screen)
  
  (import (chezscheme)
	  (only (raylib ffi)
		LoadTexture DrawTexture ImageResize LoadImage LoadTextureFromImage
		GetScreenWidth GetScreenHeight UnloadImage UnloadTexture TraceLog
		ImageFlipVertical LoadImageFromScreen)
	  (only (raylib constant) WHITE LOG_INFO)
	  (only (tool) alist-update format-green))

  (define load-texture-from-screen
    (lambda ()
      (let ([screen-img (LoadImageFromScreen)])
	(ImageResize screen-img (GetScreenWidth) (GetScreenHeight))
	(ImageFlipVertical screen-img)
	(let ([screen-tex (LoadTextureFromImage screen-img)])
	  (UnloadImage screen-img)
	  screen-tex))))

  (define resource-collect
    (lambda ()
      (let loop ()
	(let ([res (resource-guardian)])
	  (when res
	    (UnloadTexture res)
	    (TraceLog LOG_INFO (format-green "Unload Resource ~a" res))
	    (loop))))))
	
  (define resource-guardian (make-guardian))

  (define load-primitive
    (lambda (type args)
      (case type
	[(background)
	 (let ([img (apply LoadImage args)])
	   (ImageResize img (GetScreenWidth) (GetScreenHeight))
	   (let ([tex (LoadTextureFromImage img)])
	     (resource-guardian tex)
	     (UnloadImage img)
	     tex))])))
		
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

  (define static
    (lambda (res-id)
      (lambda (passed)
	(lambda (state)
	  (let* ([ress (cdr (assv ':resources state))]
		 [res (cdr (assv res-id ress))])
	    (DrawTexture res 0 0 WHITE)
	    res)))))

)

