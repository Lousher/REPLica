;;; engine/easing.ss
;;; 常用缓动曲线（已修正所有错误）

(library (engine easing)
  (export linear
          ease-in-quad ease-out-quad ease-in-out-quad
          ease-in-cubic ease-out-cubic ease-in-out-cubic
          ease-in-sine ease-out-sine ease-in-out-sine
          ease-out-bounce)
  (import (chezscheme))

  (define pi (atan 0 -1))

  (define (linear t) t)

  (define (ease-in-quad t) (* t t))
  (define (ease-out-quad t) (- 1 (* (- 1 t) (- 1 t))))
  (define (ease-in-out-quad t)
    (if (< t 0.5)
        (* 2 t t)
        (- 1 (* 2 (- 1 t) (- 1 t)))))

  (define (ease-in-cubic t) (* t t t))
  (define (ease-out-cubic t) (- 1 (expt (- 1 t) 3)))
  (define (ease-in-out-cubic t)
    (if (< t 0.5)
        (* 4 t t t)
        (- 1 (/ (expt (- 2 (* 2 t)) 3) 2))))   ; 修正：1 - (2-2t)^3 / 2

  (define (ease-in-sine t) (- 1 (cos (* t (/ pi 2)))))
  (define (ease-out-sine t) (sin (* t (/ pi 2))))
  (define (ease-in-out-sine t)
    (* 0.5 (- 1 (cos (* pi t)))))             ; 修正：标准公式 0.5*(1 - cos(πt))

  (define (ease-out-bounce t)
    (cond ((< t (/ 1 2.75)) (* 7.5625 t t))
          ((< t (/ 2 2.75)) (+ (* 7.5625 (- t 1.5) (- t 1.5)) 0.75))
          ((< t (/ 2.5 2.75)) (+ (* 7.5625 (- t 2.25) (- t 2.25)) 0.9375))
          (else (+ (* 7.5625 (- t 2.625) (- t 2.625)) 0.984375))))
  )
