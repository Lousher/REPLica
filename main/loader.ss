(library (loader)
  (export background resource-collect)
  (import (chezscheme)
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
	   (UnloadTexture res)])
	(TraceLog LOG_INFO (format-green "Unload Foreign Resurces ~a" res))]
       [else (TraceLog LOG_INFO (format-green "Unload Normal Resurces ~a" res))]
       )))
  
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
  )
