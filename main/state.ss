(library (state)
  (export make-state state-copy state-window make-window window-x window-y window-width window-height state-time state-time-pass state-previous-set! state-previous window-x-set! window-y-set! window-width-set! window-height-set!)
  (import (chezscheme))
  
  (define-record-type state
    (fields window
	    (mutable time)
	    (mutable previous)))

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
		  (state-previous s))))

  (define state-time-pass
    (lambda (s passed)
      (let ([t (state-time s)])
	(state-time-set! s (+ t passed))
	s)))
  
  )
