(library (engine state)
  (export make-state
	  state-pc state-pc-set!
	  state-stack state-stack-set!
	  state-variables state-variables-set!
	  state-root state-root-set!
	  state-time state-time-set!
	  state-dirty? state-dirty?-set!
	  state-push! state-pop!
	  state-var-ref state-var-set!)
  (import (chezscheme)
	  (scene node))

  (define-record-type state
    (fields (mutable pc)
	    (mutable stack)
	    (mutable variables)
	    (mutable root)
	    (mutable time)
	    (mutable dirty?))
    (protocol
     (lambda (new)
       (lambda (root)
	 (new 0 ;pc
	      '() ;stack
	      '() ;vars
	      root ;scene node
	      0.0 ;time
	      #t ;dirty?
	      )))))
  
  (define state-push!
    (lambda (s return-pc)
      (state-stack-set! s (cons return-pc (state-stack s)))))

  (define state-pop!
    (lambda (s)
      (let ([stack (state-stack s)])
	(if (null? stack)
	    (error 'state-pop! "Call stack empty")
	    (let ([return-pc (car stack)])
	      (state-stack-set! s (cdr stack))
	      return-pc)))))

  (define state-var-ref
    (lambda (s var)
      (let ([pair (assv var (state-variables s))])
	(if pair (cdr pair) #f))))

  (define state-var-set!
    (lambda (s var val)
      (let ([old (state-variables s)])
	(state-variables-set!
	 s (cons (cons var val)
		 (filter
		  (lambda (p)
		    (not (eqv? (car p) var)))
		  old))))))
  )
