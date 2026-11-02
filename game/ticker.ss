(library (game ticker)
  (export linear freeze)
  (import (chezscheme)
	  (game window)
	  (game picture))
  #| 目前用于驱动animator |# 
  (define linear
    (lambda (dur ani)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([p (min 1.0 (/ (- (uptime win) started) dur))]
		 [pic (ani p)])
	    ((picture-draw pic) (window-frame win)))))))

  (define freeze
    (lambda (p ani)
      (let* ([pic (ani p)]
	     [pic-draw (picture-draw pic)])
	(lambda (win)
	  (pic-draw (window-frame win))))))
  )
