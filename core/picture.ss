(library (core picture)
  (export texture->picture)
  (import
   (chezscheme)
   (render drawing)
   (core type)
   (core frame)
   (design color))

  (define texture->picture
    (lambda (tex)
      (assert (texture? tex))
      (lambda (fr)
	(assert (frame? fr))
	(draw-texture-pro
	 tex
	 (texture-source tex)
	 (make-rectangle (frame-x fr) (frame-y fr) (frame-width fr) (frame-height fr))
	 (texture-origin tex)
	 0.0 (texture-tint tex)
	 ))
      ))
  )
