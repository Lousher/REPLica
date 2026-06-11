(library (core rate)
  (export constant sine)
  (import
   (chezscheme))

  (define PI (* 4 (atan 1)))
  
  (define constant
    (lambda (speed)
      (lambda (elapsed)
	(* speed elapsed))))

  (define phase
    (lambda (elapsed period)
      (let ([t (/ elapsed period)])
	(- t (floor t)))))

  (define sine
    (lambda (peak period)
      (lambda (elapsed)
	(* peak (sin (* 2 PI (phase elapsed period)))))))

  )
