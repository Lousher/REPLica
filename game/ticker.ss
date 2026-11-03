(library (game ticker)
  (export linear freeze backward)
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
	    ((picture-drawer pic) (window-frame win))
	    (picture-deps pic))))))

  (define backward
    (lambda (dur ani)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([p (min 1.0 (/ (- (uptime win) started) dur))]
		 [pic (ani (- 1.0 p))])
	    ((picture-drawer pic) (window-frame win))
	    (picture-deps pic))))))

  (define freeze
    (lambda (p ani)
      (let* ([pic (ani p)]
	     [pic-draw (picture-drawer pic)])
	(lambda (win)
	  (pic-draw (window-frame win))
	  (picture-deps pic)))))
  )
