(load-shared-object "ffi/rpng/librpng.so")
(import (ffi rpng binding))

(define (make-gradient w h)
  ;; RGBA，4 字节/像素
  (let ([bv (make-bytevector (* w h 4) 255)]
        [xmax (max 1 (- w 1))]
        [ymax (max 1 (- h 1))])
    (do ([y 0 (+ y 1)]) ((= y h))
      (do ([x 0 (+ x 1)]) ((= x w))
        (let* ([idx (* (+ (* y w) x) 4)]
               [r (inexact->exact (round (* 255 (- 1.0 (/ x xmax)))))]
               [g (inexact->exact (round (* 255 (/ y ymax))))]
               [b 128]
               [a 255])
          (bytevector-u8-set! bv idx r)
          (bytevector-u8-set! bv (+ idx 1) g)
          (bytevector-u8-set! bv (+ idx 2) b)
          (bytevector-u8-set! bv (+ idx 3) a))))
    bv))

(define w 256)
(define h 256)

(define pixels (make-gradient w h))

;; rpng_save_image 返回 int：0 = 成功
(define result (rpng_save_image "gradient.png" pixels w h 4 8))
(printf "save result = ~a (0 = success)\n" result)
