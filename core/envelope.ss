(library (core envelope)
  (export gain->envelope crossing)
  (import
   (chezscheme)
   (core gain))

  (define gain->envelope
    (lambda (gain)
      (lambda (progress)
	(if progress gain
	    (pause gain))
	)))

  (define crossing
    (lambda (env)
      (lambda (progress)
	(pan-set! (env progress)
		  (+ -1 (* (if progress progress 0.0) 2.0))))
      ))
  )
