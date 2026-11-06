(library (game clock)
  (export loop once backward freeze pingpong after)
  (import (chezscheme))

  #| clock -> t -> p |#
  (define loop
    (lambda (dur)
      (let ([started #f])
	(lambda (t) ; t is number
	  (unless started (set! started t))
	  (mod (/ (- t started) dur) 1.0)))))

  (define once
    (lambda (dur)
      (let ([started #f])
	(lambda (t)
	  (unless started (set! started t))
	  (let ([p (/ (- t started) dur)])
	    (if (>= p 1.0) #f p))))))

  (define backward
    (lambda (dur)
      (let ([started #f])
	(lambda (t)
	  (unless started (set! started t))
	  (let ([p (- 1.0 (/ (- t started) dur))])
	    (if (<= p 0.0) #f p))))))

  (define freeze
    (lambda (p)
      (lambda (t) p)))

  (define pingpong
    (lambda (dur)
      (let ([started #f])
	(lambda (t)
	  (unless started (set! started t))
	  (let* ([t (/ (- t started) dur)]
		 [phase (mod t 2.0)])
            (if (<= phase 1.0) phase (- 2.0 phase)))))))

  (define after
    (lambda (sec clk)
      (let ([started #f])
	(lambda (t)
	  (unless started (set! started t))
	  (if (< (- t started) sec)
	      0.0
	      (clk t))))))
  )
