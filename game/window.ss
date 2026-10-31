(library (game window)
  (export make-frame frame? frame-dest frame-origin frame-rotation frame-tint
	  make-window window-delta window-delta-set!
	  window-frame
	  tick uptime
	  frame-change-tint
	  window-change-frame
	  )
  (import (chezscheme)
	  (ffi raylib binding)
	  (game type)
	  (game color))
  
  (define-record-type frame
    (fields dest origin rotation tint)
    (protocol
     (lambda (new)
       (case-lambda
	 [(d o r t) (new d o r t)]
	 [(w h)
	  (let* ([dest-init (make-rectangle 0 0 w h)]
		 [origin-init (make-vector2 0 0)]
		 [rot-init 0]
		 [tint white])
	    (new dest-init origin-init rot-init tint))
	  ]))))

  (define tick
    (lambda (win)
      (let ([passed (window-delta win)])
	(window-delta-set! win (+ passed (GetFrameTime)))
	win)))
  
  (define-record-type window
    (fields frame (mutable delta) inputs)
    (protocol
     (lambda (new)
       (case-lambda
	 [(fr d i) (new fr d i)]
	 [(fr)
	  (new fr 0.0 '())]))))

  (define uptime window-delta)

  (define frame-change-tint
    (lambda (f t)
      (let ([dest (frame-dest f)]
	    [origin (frame-origin f)]
	    [rotation (frame-rotation f)])
	(make-frame dest origin rotation t))))

  (define window-change-frame
    (lambda (w f)
      (let ([d (window-delta w)]
	    [inputs (window-inputs w)])
	(make-window f d inputs))))
  )
