(library (game clock)
  (export loop once backward freeze pingpong after)
  (import (chezscheme)
	  (game window))

  (define loop
    (lambda (dur)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (mod (/ (- (uptime win) started) dur) 1.0)))))

  (define once
    (lambda (dur)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let ([p (/ (- (uptime win) started) dur)])
	    (if (>= p 1.0) #f p))))))

  (define backward
    (lambda (dur)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let ([p (- 1.0 (/ (- (uptime win) started) dur))])
	    (if (<= p 0.0) #f p))))))

  (define freeze
    (lambda (p)
      (lambda (win) p)))

  (define pingpong
    (lambda (dur)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([t     (/ (- (uptime win) started) dur)]
		 [phase (mod t 2.0)])
            (if (<= phase 1.0) phase (- 2.0 phase)))))))

  (define after
    (lambda (sec clk)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (if (< (- (uptime win) started) sec)
	      0.0
	      (clk win))))))
  )
