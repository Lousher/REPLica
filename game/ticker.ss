(library (game ticker)
  (export linear freeze)
  (import (chezscheme)
	  (game window))

  (define linear
    (lambda (dur ani)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([p (min 1.0 (/ (- (uptime win) started) dur))]
		 [pic (ani p)])
	    (pic (window-frame win)))))))

  (define freeze
    (lambda (p ani)
      (let ([pic (ani p)])
	(lambda (win)
	  (pic (window-frame win))))))
  )
