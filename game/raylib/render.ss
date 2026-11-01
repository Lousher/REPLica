(library (game raylib render)
  (export draw-texture draw-text
	  clear-background)
  (import (chezscheme)
	  (game type)
	  (game resource)
	  (game window)
	  (ffi raylib binding))

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ type)
       (make-ftype-pointer type (foreign-alloc (ftype-sizeof type)))
       ]))

  (define draw-texture
    (let ([SRC (ftype-alloc Rectangle)]
	  [DEST (ftype-alloc Rectangle)]
	  [ORIGIN (ftype-alloc Vector2)]
	  [COLOR (ftype-alloc Color)])
      (lambda (tex fr)
	(let ([T (texture-data tex)]
	      [src (texture-source tex)]
	      [dest (frame-dest fr)]
	      [origin (frame-origin fr)]
	      [tint (frame-tint fr)])
	  (when T
	    (DrawTexturePro T
			    (Rectangle<=rectangle src)
			    (Rectangle<=rectangle dest)
			    (Vector2<=vector2 origin)
			    0.0
			    (Color<=color tint)))))))

  (define draw-text
    (let ([C (ftype-alloc Color)])
      (lambda (text w h size c)
	(DrawText text w h size (Color<=color c C)))))

  (define clear-background
    (let ([C (ftype-alloc Color)])
      (lambda (c)
	(ClearBackground (Color<=color c C)))))
  
  )
