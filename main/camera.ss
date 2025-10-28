(define bedroom-zoom-move
  (lambda ()
    (reset-Camera2D *CAMERA*)
    (let ([passed 0.0]
	  [left-bottom `(0.0 . ,(* (GetScreenHeight) 1.0))])
      (Camera2D-offset-set! *CAMERA* left-bottom)
      (Camera2D-zoom-set! *CAMERA* 2.0)
      (lambda ()
	(when (<= passed 250.0)
	  (set! passed (+ passed 0.5)))
	(Camera2D-target-set! *CAMERA* (cons passed (exact->inexact (GetScreenHeight))))
	*CAMERA*))))

