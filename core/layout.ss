(library (core layout)
  (export at beside above rotate origin resize
	  anchor-right anchor-bottom origin-right
	  anchor-percent capture captured)
  (import
   (chezscheme)
   (core frame)
   (core type))

  (define at
    (lambda (fn x-f y-f)
      (let ([x-fn (if x-f x-f (lambda (x) x))]
	    [y-fn (if y-f y-f (lambda (y) y))])
	(lambda (fr)
	  (let ([w (frame-width fr)]
		[h (frame-height fr)]
		[acr (frame-anchor fr)]
		[ori (frame-origin fr)]
		[rot (frame-rotation fr)])
	    (fn (make-frame w h (make-vector2
				 (x-fn (vector2-x acr))
				 (y-fn (vector2-y acr))) ori rot))
	    )))
      ))

  (define origin-right
    (lambda (fn)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h acr
			  (make-vector2
			   w
			   (vector2-y ori)) rot))
	  ))))
  
  (define anchor-right
    (lambda (fn)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h
			  (make-vector2
			   w
			   (vector2-y acr)) ori rot))
	  ))))

  (define anchor-percent
    (lambda (fn wp hp)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h
			  (make-vector2
			   (* wp w)
			   (* hp h)
			   ) ori rot))
	  ))))

  (define anchor-bottom
    (lambda (fn)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (fn (make-frame w h
			  (make-vector2
			   (vector2-x acr)
			   h) ori rot))
	  ))))

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
	      (fn-a fr-a)
	      (fn-b fr-b)
	      ))))))

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
	      (fn-a fr-a)
	      (fn-b fr-b)
	      ))))))

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

  (define *return* (make-parameter (lambda (x) #f)))
  (define capture
    (lambda (sig)
      (lambda (fr)
	((*return*) sig)
	)))
					; for stage only!
  (define captured
    (lambda (fn)
      (let ([status 'default])
	(case-lambda
	  [(fr)
	   (parameterize ([*return* (lambda (x) (set! status x))])
	     (fn fr))]
	  [() (let-values ([(p s) (fn)])
		(values p status))])))
    )
  )
