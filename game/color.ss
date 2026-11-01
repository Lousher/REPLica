(library (game color)
  (export white black
	  color-alpha)
  (import (chezscheme)
	  (game type))

  (define color-alpha
    (lambda (c al)
      (assert (<= 0.0 al 1.0))
      (let ([r (color-r c)]
	    [g (color-g c)]
	    [b (color-b c)]
	    [a (color-a c)])
	(make-color r g b (inexact->exact (round (* a al)))))
      ))

  (define white (make-color 255 255 255 255))
  (define black (make-color 0 0 0 255))
  
  )
