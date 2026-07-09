(library (core envelope)
  (export gain->envelope crossing)
  (import
   (chezscheme)
   (core gain))

  (define gain->envelope
    (lambda (gain)
      (lambda (progress) gain)))

  (define crossing
    (lambda (env)
      (lambda (progress)
	(pan-set! (env progress)
		  (+ -1 (* progress 2.0))))
      ))
  )
