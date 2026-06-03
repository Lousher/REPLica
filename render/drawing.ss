(library (render drawing)
  (export draw-texture-pro)
  (import (chezscheme)
	  (ffi raylib binding)
	  (render resource)
	  (core type))

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ ftype)
       (make-ftype-pointer ftype (foreign-alloc (ftype-sizeof ftype)))]))

  (define draw-texture-pro
    (let ([src-fptr (ftype-alloc Rectangle)]
	  [dest-fptr (ftype-alloc Rectangle)]
	  [origin-fptr (ftype-alloc Vector2)]
	  [tint-fptr (ftype-alloc Color)])
      (lambda (tex src dest origin rotation tint)
	(assert (asset? tex))
	(assert (rectangle? src))
	(assert (rectangle? dest))
	(assert (vector2? origin))
	(assert (flonum? rotation))
	(assert (color? tint))

	(rectangle->Rectangle src src-fptr)
	(rectangle->Rectangle dest dest-fptr)
	(vector2->Vector2 origin origin-fptr)
	(color->Color tint tint-fptr)
	
	(DrawTexturePro
	 (asset-pointer tex)
	 src-fptr
	 dest-fptr
	 origin-fptr
	 rotation
	 tint-fptr)))
    )
  )
