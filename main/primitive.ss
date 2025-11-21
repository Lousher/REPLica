(library (primitive)
  (export preload static)

  (import (chezscheme)
	  (only (raylib ffi)
		LoadTexture DrawTexture ImageResize LoadImage LoadTextureFromImage
		GetScreenWidth GetScreenHeight UnloadImage)
	  (only (raylib constant) WHITE)
	  (only (tool) alist-update))

  (define load-primitive
    (lambda (type args)
      (case type
	[(background)
	 (let ([img (apply LoadImage args)])
	   (ImageResize img (GetScreenWidth) (GetScreenHeight))
	   (let ([tex (LoadTextureFromImage img)])
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

  (define static
    (lambda (res-id)
      (lambda (passed)
	(lambda (state)
	  (let* ([ress (cdr (assv ':resources state))]
		 [res (cdr (assv res-id ress))])
	    (DrawTexture res 0 0 WHITE)
	    res)))))

)

