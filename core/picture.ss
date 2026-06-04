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
	      [anchor (frame-anchor fr)]
	      [origin (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (let ([acr-x (vector2-x anchor)]
		[acr-y (vector2-y anchor)])
	    (draw-texture-pro
	     tex
	     (texture-source tex)
	     (make-rectangle
	      acr-x acr-y
	      (frame-width fr) (frame-height fr))
	     origin
	     (frame-rotation fr) (texture-tint tex)
	     ))))
      ))

  (define beside
    (lambda (pic-a pic-b ratio)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (let ([acr-x (vector2-x acr)]
		[acr-y (vector2-y acr)]
		[ori-x (vector2-x ori)]
		[ori-y (vector2-y ori)])
	    (let ([fr-a (make-frame (* w ratio) h acr ori rot)]
		  [fr-b (make-frame (* w (- 1 ratio)) h acr
				    (make-vector2
				     (- ori-x (* w ratio))
				     ori-y)
				    rot)])
	      (pic-a fr-a)
	      (pic-b fr-b)))))))

  (define above
    (lambda (pic-a pic-b ratio)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (let ([acr-x (vector2-x acr)]
		[acr-y (vector2-y acr)]
		[ori-x (vector2-x ori)]
		[ori-y (vector2-y ori)])
	    (let ([fr-a (make-frame w (* h ratio) acr ori rot)]
		  [fr-b (make-frame w (* h (- 1 ratio)) acr
				    (make-vector2
				     ori-x
				     (- ori-y (* h ratio))
				     )
				    rot)])
	      (pic-a fr-a)
	      (pic-b fr-b)))))))

  )
