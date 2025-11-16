(define phone
  (lambda (phone-w phone-h)
    (let* ([w (GetScreenWidth)]
	   [h (GetScreenHeight)]
	   [x (/ (- w phone-w) 2.0)]
	   [y (/ (- h phone-h) 2.0)]
	   [round-rec (make-Rectangle x y (inexact phone-w) (inexact phone-h))])
      (case-lambda
	[(state)
	 (DrawRectangleRoundedLinesEx round-rec 0.3 8 5.0 BLACK)]
	[]))))
	  

