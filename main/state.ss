(library (state)
  (export make-state state-copy state-window make-window window-x window-y window-width window-height)
  (import (chezscheme))
  
  (define-record-type state
    (fields window))

  (define-record-type window
    (fields x y width height))

  (define window-copy
    (lambda (win)
      (make-window
       (window-x win)
       (window-y win)
       (window-width win)
       (window-height win))))

  (define state-copy
    (lambda (s)
      (make-state (window-copy (state-window s)))))
  
  )
