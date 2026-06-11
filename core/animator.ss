(library (core animator)
  (export *PASSED*
	  static spin)
  (import
   (ffi raylib binding)
   (core frame)
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
  )
