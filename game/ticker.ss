(library (game ticker)
  (export once freeze backward loop)
  (import (chezscheme)
	  (game window)
	  (game picture)
	  (game clip))
  #| 目前用于驱动animator  #f for ending|#
  
  (define once
    (lambda (dur curve)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([p (min 1.0 (/ (- (uptime win) started) dur))]
		 [out (curve p)])
	    (if (>= p 1.0) #f
		(cond
		 [(picture? out) 
		  ((picture-drawer out) (window-frame win))
		  (picture-deps out)]
		 [(clip? out)
		  ((clip-player out) (window-channel win))
		  (clip-deps out)]))
	    )))))

  (define backward
    (lambda (dur curve)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([p (min 1.0 (/ (- (uptime win) started) dur))]
		 [out (curve (- 1.0 p))])
	    (if (>= p 1.0) #f
		(cond
		 [(picture? out) 
		  ((picture-drawer out) (window-frame win))
		  (picture-deps out)]
		 [(clip? out)
		  ((clip-player out) (window-channel win))
		  (clip-deps out)]))
	    )))))

  (define freeze
    (lambda (p curve)
      (let* ([out (curve p)]
	     [func (cond [(picture? out) (picture-drawer out)]
			 [(clip? out) (clip-player out)])]
	     [deps (cond [(picture? out) (picture-deps out)]
			 [(clip? out) (clip-deps out)])]
	     [win-sub (cond [(picture? out) window-frame]
			    [(clip? out) window-channel])])
	(lambda (win)
	  (func (win-sub win))
	  deps))))

  (define loop
    (lambda (dur curve)
      (let ([started #f])
	(lambda (win)
	  (unless started (set! started (uptime win)))
	  (let* ([p (mod (/ (- (uptime win) started) dur) 1.0)]
		 [out (curve p)])
	    (if (>= p 1.0) #f
		(cond
		 [(picture? out) 
		  ((picture-drawer out) (window-frame win))
		  (picture-deps out)]
		 [(clip? out)
		  ((clip-player out) (window-channel win))
		  (clip-deps out)])))))))
  )
