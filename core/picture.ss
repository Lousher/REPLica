(library (core picture)
  (export texture->picture beside above)
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
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [pivot (frame-pivot fr)])
	  (draw-texture-pro
	   tex
	   (texture-source tex)
	   (make-rectangle (frame-x fr) (frame-y fr) (frame-width fr) (frame-height fr))
	   (make-vector2
	    (* w (vector2-x pivot))
	    (* h (vector2-y pivot))
	    )
	   (frame-rotation fr) (texture-tint tex)
	   )))
      ))

  (define beside
    (lambda (pic-a pic-b ratio)
      (lambda (fr)
	(let ([x (frame-x fr)]
	      [y (frame-y fr)]
	      [w (frame-width fr)]
	      [h (frame-height fr)]
	      [piv (frame-pivot fr)]
	      [rot (frame-rotation fr)])
	  (let ([fr-a (make-frame x y (* w ratio) h piv rot)]
		[fr-b (make-frame (+ x (* w ratio)) y (* w (- 1 ratio)) h piv rot)])
	    (pic-a fr-a)
	    (pic-b fr-b))))))

  (define above
    (lambda (pic-a pic-b ratio)
      (lambda (fr)
	(let ([x (frame-x fr)]
	      [y (frame-y fr)]
	      [w (frame-width fr)]
	      [h (frame-height fr)]
	      [piv (frame-pivot fr)]
	      [rot (frame-rotation fr)])
	  (let ([fr-a (make-frame x y w (* h ratio) piv rot)]
		[fr-b (make-frame x (+ y (* h ratio)) w (* h (- 1 ratio)) piv rot)])
	    (pic-a fr-a)
	    (pic-b fr-b))))))

  )
