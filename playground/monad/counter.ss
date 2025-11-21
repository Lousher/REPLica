(import (monad))

(define (inc)
  (modify 1+))

(define (dec)
  (modify 1-))

(define main
  (lambda ()
    (perform
     (inc)
     (inc)
     (dec)
     (n <- ref)
     (return (* n n n))
     (m <- ref)
     (return (* m m m m)))))
