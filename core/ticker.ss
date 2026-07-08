(library (core ticker)
  (export *PASSED* once loop yoyo )
  (import (chezscheme))

  (define *PASSED* (make-parameter 0.0))

					;ticker is the driver that motivate the animator in real time!
  (define once
    (lambda (t)
      (let ([started #f])
	(lambda ()
	  (unless started (set! started (*PASSED*)))
	  (let ([p (/ (- (*PASSED*) started) t)])
	    (if (>= p 1.0) 1.0 p))))
      ))

  (define loop
    (lambda (t)
      (let ([started #f])
	(lambda ()
	  (unless started (set! started (*PASSED*)))
	  (let* ([elpased (- (*PASSED*) started)]
		 [p (mod (/ elpased t) 1)])
	    p)
	  ))
      ))

  (define yoyo
    (lambda (t)
      (let ([started #f])
	(lambda ()
	  (unless started (set! started (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) started)]
		 [cycle (/ elapsed t)]
		 [p (- 1.0 (abs (- (mod cycle 2.0) 1.0)))])
	    p)))))
  
  )
