(library (game clock)
  (export loop once backward freeze pingpong after)
  (import (chezscheme)
	  (game world))

  #| clock -> timeline -> p |#
  (define loop
    (lambda (dur)
      (let ([started #f])
	(lambda (tl)
	  (unless started (set! started (timeline-uptime tl)))
	  (mod (/ (- (timeline-uptime tl) started) dur) 1.0)))))

  (define once
    (lambda (dur)
      (let ([started #f])
	(lambda (tl)
	  (unless started (set! started (timeline-uptime tl)))
	  (let ([p (/ (- (timeline-uptime tl) started) dur)])
	    (if (>= p 1.0) #f p))))))

  (define backward
    (lambda (dur)
      (let ([started #f])
	(lambda (tl)
	  (unless started (set! started (timeline-uptime tl)))
	  (let ([p (- 1.0 (/ (- (timeline-uptime tl) started) dur))])
	    (if (<= p 0.0) #f p))))))

  (define freeze
    (case-lambda
      [(p)
       (lambda (tl) p)]
      [() (freeze 0)]))

  (define pingpong
    (lambda (dur)
      (let ([started #f])
	(lambda (tl)
	  (unless started (set! started (timeline-uptime tl)))
	  (let* ([t (/ (- (timeline-uptime tl) started) dur)]
		 [phase (mod t 2.0)])
            (if (<= phase 1.0) phase (- 2.0 phase)))))))

  (define after
    (lambda (sec clk)
      (let ([started #f])
	(lambda (tl)
	  (unless started (set! started (timeline-uptime tl)))
	  (if (< (- (timeline-uptime tl) started) sec)
	      0.0
	      (clk tl))))))
  )
