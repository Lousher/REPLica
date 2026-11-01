(library (game raylib render)
  (export draw-texture
	  clear-background)
  (import (chezscheme)
	  (game type)
	  (game resource)
	  (game window)
	  (ffi raylib binding))

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
			    (Rectangle<=rectangle src SRC)
			    (Rectangle<=rectangle dest DEST)
			    (Vector2<=vector2 origin ORIGIN)
			    0.0
			    (Color<=color tint COLOR)))))))
  
  (define clear-background
    (let ([C (ftype-alloc Color)])
      (lambda (c)
	(ClearBackground (Color<=color c C)))))


  )
