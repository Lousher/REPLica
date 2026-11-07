(library (game clock)
  (export loop once backward freeze pingpong after)
  (import (chezscheme))

  #| clock -> t -> p |#
  (define loop
    (lambda (dur)
      (lambda (t) ; t is number
	(mod (/ t dur) 1.0))))

  (define once
    (lambda (dur)
      (lambda (t)
	(let ([p (/ t dur)])
	  (if (>= p 1.0) #f p)))))

  (define backward
    (lambda (dur)
      (lambda (t)
	(let ([p (- 1.0 (/ t dur))])
	  (if (<= p 0.0) #f p)))))

  (define freeze
    (lambda (p)
      (lambda (t) p)))

  (define pingpong
    (lambda (dur)
      (lambda (t)
	(let* ([t (/ t dur)]
	       [phase (mod t 2.0)])
          (if (<= phase 1.0) phase (- 2.0 phase))))))

  (define after
    (lambda (sec clk)
      (lambda (t)
	(if (< t sec)
	    0.0
	    (clk (- t sec))))))
  )
