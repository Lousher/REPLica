(library (engine signal)
  (export make-signal
	  signal-ref
	  signal-set!
	  signal-next!
	  signal-computed
	  signal-effect
	  )
  (import
   (chezscheme))

  (define *CURRENT_EFFECT* (make-parameter #f))
  
  (define-record-type signal
    (fields
     box
     (mutable listeners))
    (protocol
     (lambda (v)
       (lambda (new)
	 (new (box v) '()))))
    )
  
  (define signal-ref
    (lambda (sig)
      (let ([cur (*CURRENT_EFFECT*)])
	(when cur
	  (signal-listeners-set! sig (cons cur (signal-listeners sig))))
	(unbox (signal-box sig)))))

  (define signal-next!
    (lambda (sig fn)
      (let ([sig-box (signal-box sig)]
	    [sig-liss (signal-listeners sig)])
	(let ([old (signal-ref sig)])
	  (box-cas! sig-box old (fn old)))
	(for-each (lambda (fn) (fn)) sig-liss))))

  (define signal-set!
    (lambda (sig updated)
      (let* ([b (signal-box sig)]
	     [bv (unbox b)]
	     [liss (signal-listeners sig)])
	(box-cas! b bv updated)
	(for-each (lambda (fn) (fn)) liss))))

  (define signal-effect
    (lambda (fn)
      (parameterize ([*CURRENT_EFFECT* fn])
	(fn))))

  (define signal-computed
    (lambda (fn)
      (let ([memo (make-signal #f)])
	(signal-effect
	 (lambda ()
	   (signal-set! memo (fn))))
	memo)))
  )
