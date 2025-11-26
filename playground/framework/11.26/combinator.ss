(library (combinator)
  (export parallel join sequential)
  (import (chezscheme))

  (define parallel
    (lambda animators
      (lambda (passed)
	(lambda (state)
	  (for-each
	   (lambda (anim)
	     ((anim passed) state))
	   animators)))))

  (define join
    (lambda (ani1 time ani2)
      (lambda (passed)
	(lambda (state)
	  ((ani1 passed) state)
	  (when (>= passed time)
	    ((ani2 (- passed time)) state))))))

  (define (sequential . args)
    (let loop ([rest args])
      (cond
       [(null? rest) 
	(lambda (p) (lambda (s) (void)))]
       [(null? (cdr rest)) 
	(car rest)]
       [else
	(let ([current-anim (car rest)]
              [delay-time   (cadr rest)]
              [next-items   (cddr rest)])
          (join current-anim 
		delay-time 
		(loop next-items)))])))

  )
