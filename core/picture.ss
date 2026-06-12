(library (core picture)
  (export texture->picture beside above
	  rotate layer stroke fade
	  *TINT*)
  (import
   (chezscheme)
   (render drawing)
   (core type)
   (core frame)
   (design color))

  (define *TINT* (make-parameter white))
  
  (define texture->picture
    (lambda (tex)
      (assert (texture? tex))
      (lambda (fr)
	(assert (frame? fr))
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [anchor (frame-anchor fr)]
	      [origin (frame-origin fr)]
	      [rot (frame-rotation fr)]
	      [src (texture-source tex)]
	      [tex-w (texture-width tex)]
	      [tex-h (texture-height tex)])
	  (let ([acr-x (vector2-x anchor)]
		[acr-y (vector2-y anchor)]
		[flip-x? (negative? w)]
		[flip-y? (negative? h)]
		)
	    (let ([src-w (if flip-x? (- tex-w) tex-w)]
		  [src-h (if flip-y? (- tex-h) tex-h)]
		  [src-x (if flip-x? tex-w (rectangle-x src))]
		  [src-y (if flip-y? tex-h (rectangle-y src))])
	      (draw-texture-pro
	       tex
	       (make-rectangle
		src-x src-y src-w src-h)
	       (make-rectangle
		acr-x acr-y
		(frame-width fr) (frame-height fr))
	       origin
	       (frame-rotation fr)
	       (color-multiply
		(texture-tint tex)
		(*TINT*))
	       )))))
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

  (define layer
    (lambda pics
      (lambda (fr)
	(for-each (lambda (p) (p fr)) pics))
      ))

  (define rotate
    (lambda (pic angle)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h acr ori (+ rot angle)))
	  ))))

  (define stroke
    (lambda (pic thickness color)
      (lambda (fr)
	(let ([c-tex (color->texture color 1 1)]
	      [w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)]
	      [thick (* 1.0 thickness)])
	  (let ([x (vector2-x ori)]
		[y (vector2-y ori)]
		[acr-x (vector2-x acr)]
		[acr-y (vector2-y acr)]
		[line-pic (texture->picture c-tex)])
	    (let ([top-fr (make-frame
			   w thick
			   acr ori rot)]
		  [bottom-fr (make-frame
			      w thick
			      acr
			      (make-vector2 x (+ y (- thick h)))
			      rot)]
		  [left-fr (make-frame
			    thick h
			    acr ori rot)]
		  [right-fr (make-frame
			     thick h
			     acr (make-vector2 (+ x (- thick w)) y)
			     rot)])
	      (pic fr)
	      (line-pic top-fr)
	      (line-pic bottom-fr)
	      (line-pic left-fr)
	      (line-pic right-fr)))
	  ))))

  (define fade
    (lambda (pic alpha)
      (lambda (fr)
	(let ([local (color-alpha white alpha)])
	  (parameterize ([*TINT* (color-multiply (*TINT*) local)])
	    (pic fr))))
      ))
  )
