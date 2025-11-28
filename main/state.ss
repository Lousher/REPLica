(library (state)
  (export state-init state-time-pass)
  (import (chezscheme)
	  (tool))

  (define state-init
    (lambda ()
      `((:time . 0.0))))

  (define state-time-pass
    (lambda (s dt)
      (alist-update s ':time (lambda (t) (+ t dt)))))
  )
