(library (core layout)
  (export at beside above layer rotate origin resize)
  (import
   (chezscheme)
   (core frame)
   (core type))

  (define at
    (lambda (fn x-f y-f)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h (make-vector2
			       (x-f (vector2-x acr))
			       (y-f (vector2-y acr))) ori rot))
	  ))
      ))

  (define beside
    (lambda (fn-a fn-b ratio)
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
	      (let-values ([(aw ah) (fn-a fr-a)]
			   [(bw bh) (fn-b fr-b)])
		(values (+ aw bw) (max ah bh)))))))))

  (define above
    (lambda (fn-a fn-b ratio)
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
	      (let-values ([(aw ah) (fn-a fr-a)]
			   [(bw bh) (fn-b fr-b)])
		(values (max aw bw)
			(+ ah bh)))))))))

  (define layer
    (lambda fns
      (lambda (fr)
	(let ([vals (map (lambda (pic)
			   (call-with-values
			       (lambda () (pic fr))
			     list))
			 fns)])
	  (let ([res (apply map list vals)])
	    (values (apply max (car res))
		    (apply max (cadr res)))))
	)
      ))

  (define rotate
    (lambda (fn angle-f)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h acr ori (angle-f rot)))
	  ))))

  
  (define origin
    (lambda (fn ox-f oy-f)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h acr
			  (make-vector2
			   (ox-f (vector2-x ori))
			   (oy-f (vector2-y ori))) rot))
	  ))))

  (define resize
    (lambda (fn w-f h-f)
      (let ([w-fn (if w-f w-f (lambda (w) w))]
	    [h-fn (if h-f h-f (lambda (h) h))])
	(lambda (fr)
	  (let ([w (frame-width fr)]
		[h (frame-height fr)]
		[ori (frame-origin fr)]
		[acr (frame-anchor fr)]
		[rot (frame-rotation fr)])
	    (fn (make-frame
		 (inexact (w-fn w))
		 (inexact (h-fn h)) acr ori rot))
	    )))))
  )
