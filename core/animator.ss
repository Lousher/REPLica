(library (core animator)
  (export *PASSED*
	  static spin shake crossfade overlay
	  appear disappear unfurl dissolve)
  (import
   (ffi raylib binding)
   (core frame)
   (core type)
   (only (core picture) *TINT*)
   (chezscheme)
   (design color)
   (core picture)
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

  (define shake
    (lambda (ani intensity duration)
      (let ([start #f])
	(lambda (f)
	  (unless start
	    (set! start (*PASSED*)))
	  (let ([elapsed (- (*PASSED*) start)])
	    (if (>= elapsed duration)
		(ani f)
		(let* ([decay (- 1 (/ elapsed duration))]
		       [angle (* elapsed 70.0)]
		       [dx (* intensity (sin angle) decay)]
		       [dy (* intensity (cos (* angle 1.3)) decay)])
		  (let ([w (frame-width f)]
			[h (frame-height f)]
			[acr (frame-anchor f)]
			[ori (frame-origin f)]
			[rot (frame-rotation f)])
		    (ani
		     (make-frame
		      w h acr
		      (make-vector2 (+ dx (vector2-x ori))
				    (+ dy (vector2-y ori))) rot))
		    ))))))))
  
  (define crossfade
    (lambda (ani1 ani2 duration easing)
      (overlay
       (disappear ani1 duration easing)
       (appear ani2 duration easing))))

  (define appear
    (lambda (ani duration easing)
      (let ([start #f]
	    )
	(lambda (fr)
	  (unless start
	    (set! start (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) start)]
		 [t (min 1.0 (/ elapsed duration))]
		 [progress (easing t)]
		 [a (floor (* progress 255))])
	    ((fade ani a) fr))))
      ))

  (define disappear
    (lambda (ani duration easing)
      (let ([start #f])
	(lambda (fr)
	  (unless start
	    (set! start (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) start)]
		 [t (min 1.0 (/ elapsed duration))]
		 [progress (easing t)]
		 [a (floor (* (- 1 progress) 255))])
	    ((fade ani a) fr))))
      ))

  (define overlay
    (lambda anis
      (lambda (fr)
	(for-each
	 (lambda (ani) (ani fr))
	 anis))
      ))

  (define unfurl
    (lambda (ani duration easing)
      (let ([start #f])
	(lambda (f)
	  (unless start
	    (set! start (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) start)]
		 [t (min 1.0 (/ elapsed duration))]
		 [p (easing t)])
	    (let ([w (frame-width f)]
		  [h (frame-height f)]
		  [acr (frame-anchor f)]
		  [ori (frame-origin f)]
		  [rot (frame-rotation f)])
	      (let-values ([(rw rh) (ani (make-frame 0.0 0.0 acr ori rot))])
		(BeginScissorMode
		 (exact (round (- (vector2-x ori) (vector2-x acr))))
		 (exact (round (- (vector2-y ori) (vector2-y acr))))
		 (exact (round (* w p))) (exact (round h)))
		(ani f)
		(EndScissorMode)
		(values (* w p) h)))
	    )
	  ))))

  (define dissolve
    (lambda (ani masked duration easing)
      (let ([start #f])
	(lambda (fr)
	  (unless start (set! start (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) start)]
		 [t (min 1.0 (- elapsed duration))]
		 [p (easing t)])
	    ((mask ani masked p) fr))
	  ))))

  )
