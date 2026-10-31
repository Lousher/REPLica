(library (game raylib render)
  (export draw-texture draw-text)
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

  (define draw-text
    (let ([C (ftype-alloc Color)])
      (lambda (text w h size c)
	(DrawText text w h size (Color<=color c C)))))
  
  )
