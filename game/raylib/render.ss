(library (game raylib render)
  (export draw-texture)
  (import (chezscheme)
	  (game type)
	  (game resource)
	  (ffi raylib binding))

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ type)
       (make-ftype-pointer type (foreign-alloc (ftype-sizeof type)))
       ]))
  
  (define draw-texture
    (let ([C (ftype-alloc Color)])
      (lambda (tex w h c)
	(DrawTexture (texture-data tex) w h (Color<=color c C)))))
  
  )
