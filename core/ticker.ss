(library (core ticker)
  (export *PASSED* once loop yoyo)
  (import (chezscheme))

  (define *PASSED* (make-parameter 0.0))

  (define once
    (lambda (t easing ani)
      (let ([started #f])
	(lambda (f)
	  (unless started (set! started (*PASSED*)))
	  (let* ([elpased (- (*PASSED*) started)]
		 [p (min 1.0 (/ elpased t))])
	    ((ani (easing p)) f)))
	)))

  (define loop
    (lambda (t easing ani)
      (let ([started #f])
	(lambda (f)
	  (unless started (set! started (*PASSED*)))
	  (let* ([elpased (- (*PASSED*) started)]
		 [p (mod (/ elpased t) 1)])
	    ((ani (easing p)) f))
	  ))
      ))

  (define yoyo
    (lambda (t easing ani)
      (let ([started #f])
	(lambda (f)
	  (unless started (set! started (*PASSED*)))
	  (let* ([elapsed (- (*PASSED*) started)]
		 [cycle (- elapsed t)]
		 [p (- 1 (abs (- (mod cycle 2) 1)))])
	    ((ani (easing p)) f))))))
  
  )
