(library (state)
  (export make-state state-copy state-window make-window window-x window-y window-width window-height state-time state-time-pass  window-x-set! window-y-set! window-width-set! window-height-set! make-resource resource-lock resource-status resource-status-set! resource-data resource-data-set!)
  (import (chezscheme))
  
  (define-record-type state
    (fields window
	    (mutable time)
	    ))

  (define-record-type resource
    (fields
     (immutable lock)
     (mutable status)
     (mutable data)))
 
  (define-record-type window
    (fields
     (mutable x)
     (mutable y)
     (mutable width)
     (mutable height)))

  (define window-copy
    (lambda (win)
      (make-window
       (window-x win)
       (window-y win)
       (window-width win)
       (window-height win))))

  (define state-copy
    (lambda (s)
      (make-state (window-copy (state-window s))
		  (state-time s)
		  )))

  (define state-time-pass
    (lambda (s passed)
      (let ([t (state-time s)])
	(state-time-set! s (+ t passed))
	s)))
  
  )
