(library (core animator)
  (export *PASSED*
	  static spin shock crossfade)
  (import
   (ffi raylib binding)
   (core frame)
   (core type)
   (only (core picture) *TINT*)
   (chezscheme)
   (design color)
   )

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
	    (set! start (*PASSED*)))
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
	    (set! start (*PASSED*)))
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
  
  (define crossfade
    (lambda (ani1 ani2 duration easing)
      (let ([start #f])
	(lambda (fr)
	  (unless start
	    (set! start (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) start)]
		 [t (min 1.0 (/ elapsed duration))]
		 [progress (easing t)]
		 [alpha1 (floor (* (- 1 progress) 255))]
		 [alpha2 (floor (* progress 255))])
	    (parameterize ([*TINT* (color-alpha white alpha1)])
	      (ani1 fr))
	    (parameterize ([*TINT* (color-alpha white alpha2)])
	      (ani2 fr)))))))
  )
