(library (engine event)
  (export hover? frame->vector2s both key-down? mouse-down? never)
  (import
   (chezscheme)
   (core frame)
   (core type)
   (ffi raylib binding)
   )

  (define MAX_POLY_EDGES 10)
  (define frame->vector2s
    (lambda (fr)
      (let* ([w (frame-width fr)]
	     [h (frame-height fr)]
	     [acr (frame-anchor fr)]
	     [ori (frame-origin fr)]
	     [rot (frame-rotation fr)]
	     [acrx (vector2-x acr)]
	     [acry (vector2-y acr)]
	     [orix (vector2-x ori)]
	     [oriy (vector2-y ori)]
	     [pi (* 4 (atan 1))]
	     [r-sin (sin (* pi (/ rot 180)))]
	     [r-cos (cos (* pi (/ rot 180)))])
	(let* ([left-up-x (+ acrx (- (* orix r-cos)) (* oriy r-sin))]
	       [left-up-y (+ acry (- (* orix r-sin)) (- (* oriy r-cos)))]
	       [right-up-x (+ left-up-x (* w r-cos))]
	       [right-up-y (+ left-up-y (* w r-sin))]
	       [left-bottom-x (+ left-up-x (- (* h r-sin)))]
	       [left-bottom-y (+ left-up-y (* h r-cos))]
	       [right-bottom-x (+ left-bottom-x (* w r-cos))]
	       [right-bottom-y (+ left-bottom-y (* w r-sin))])
	  (list
	   (make-vector2 left-up-x left-up-y)
	   (make-vector2 right-up-x right-up-y)
	   (make-vector2 right-bottom-x right-bottom-y)
	   (make-vector2 left-bottom-x left-bottom-y)
	   ))
	))
    )

  (define hover?
    (let* ([vec2-size (ftype-sizeof Vector2)]
	   [poly-ptr (foreign-alloc (* MAX_POLY_EDGES vec2-size))]
	   [poly-fptr (make-ftype-pointer Vector2 poly-ptr)])
      (lambda (fr)
	(let* ([vec2s (frame->vector2s fr)]
	       [len (length vec2s)]
	       [pos (GetMousePosition)])
	  (for-each
	   (lambda (vec i)
	     (ftype-set! Vector2 (x) poly-fptr i (vector2-x vec))
	     (ftype-set! Vector2 (y) poly-fptr i (vector2-y vec))
	     )
	   vec2s (iota len)
	   )
	  (let ([res (CheckCollisionPointPoly pos poly-fptr len)])
	    res
	    )
	  ))))

  (define key-down?
    (lambda (key)
      (lambda (fr)
	(IsKeyDown key))))

  (define mouse-down?
    (lambda (mouse)
      (lambda (fr)
	(IsMouseButtonDown mouse))))

  (define both
    (lambda (ev-a ev-b)
      (lambda (fr)
	(and (ev-a fr) (ev-b fr)))))

  (define never
    (lambda (fr) #f))
  )
