(library (core animator)
  (export *PASSED*
	  static spin shock)
  (import
   (ffi raylib binding)
   (core frame)
   (core type)
   (chezscheme))

  (define *FPS* 60)
  (define *PASSED* (make-parameter 0.0))
  
  (define static
    (lambda (pic)
      pic))

  (define spin
    (lambda (pic rate)
      (let ([start #f])
	(lambda (f)
	  (unless start
	    (set! start (GetTime)))
	  (let ([passed (*PASSED*)]
		[w (frame-width f)]
		[h (frame-height f)]
		[acr (frame-anchor f)]
		[ori (frame-origin f)]
		[rot (frame-rotation f)])
	    (pic
	     (make-frame
	      w h acr ori (+ rot (rate (- passed start)))))
	    ))))
    )

  (define shock
    (lambda (pic intensity duration)
      (let ([start #f])
	(lambda (f)
	  (unless start
	    (set! start (GetTime)))
	  (let ([elapsed (- (*PASSED*) start)])
	    (if (>= elapsed duration)
		(pic f)
		(let* ([decay (- 1 (/ elapsed duration))]
		       [angle (* elapsed 70.0)]
		       [dx (* intensity (sin angle) decay)]
		       [dy (* intensity (cos (* angle 1.3)) decay)])
		  (let ([w (frame-width f)]
			[h (frame-height f)]
			[acr (frame-anchor f)]
			[ori (frame-origin f)]
			[rot (frame-rotation f)])
		    (pic
		     (make-frame
		      w h acr
		      (make-vector2 (+ dx (vector2-x ori))
				    (+ dy (vector2-y ori))) rot))
		    ))))))))
  )
