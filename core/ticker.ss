(library (core ticker)
  (export *PASSED* once loop yoyo hold)
  (import
   (chezscheme)
   )

  (define *PASSED* (make-parameter 0.0))

  (define hold
    (lambda (t)
      (let ([started #f])
	(lambda (time)
	  (unless started (set! started time))
	  (let ([p (/ (- time started) t)])
	    (min 1.0 p))))))

  (define once
    (lambda (t)
      (let ([started #f])
	(lambda (time)
	  (unless started (set! started time))
	  (let ([p (/ (- time started) t)])
	    (if (>= p 1.0) #f p))))
      ))

  (define loop
    (lambda (t)
      (let ([started #f])
	(lambda (time)
	  (unless started (set! started time))
	  (let* ([elpased (- time started)]
		 [p (mod (/ elpased t) 1)])
	    p)
	  ))
      ))

  (define yoyo
    (lambda (t)
      (let ([started #f])
	(lambda (time)
	  (unless started (set! started time))
	  (let* ([elapsed (- time started)]
		 [cycle (/ elapsed t)]
		 [p (- 1.0 (abs (- (mod cycle 2.0) 1.0)))])
	    p)))))
  
  )
