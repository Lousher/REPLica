(define zoom-bedroom
  (lambda ()
    (let ([passed 0.0]
	  [camera (init-Camera2D)]
	  [left-bottom `(0.0 . ,(* (GetScreenHeight) 1.0))])
	(Camera2D-offset-set! camera left-bottom)
	(Camera2D-zoom-set! camera 2.0)
	(lambda (x)
	  (when (<= passed 250.0)
	    (set! passed (+ passed 0.5)))
	  (Camera2D-target-set! camera (cons passed (exact->inexact (GetScreenHeight))))
	  camera))))
