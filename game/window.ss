(library (game window)
  (export make-frame frame? frame-dest frame-origin frame-rotation frame-tint
	  make-window window-delta window-delta-set! window-mouse
	  window-frame window-channel
	  mouse-position
	  tick uptime
	  frame-change-tint frame-change-dest
	  window-change-frame
	  make-channel channel? channel-volume channel-pan channel-pitch
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
	  (let* ([dest-init (make-rectangle 0.0 0.0 (inexact w) (inexact h))]
		 [origin-init (make-vector2 0.0 0.0)]
		 [rot-init 0]
		 [tint white])
	    (new dest-init origin-init rot-init tint))
	  ]))))

  (define tick
    (lambda (win)
      (let ([passed (window-delta win)])
	(window-delta-set! win (+ passed (GetFrameTime)))
	(window-mouse-set! win (mouse-snapshot (window-mouse win)))
	win)))
  
  (define mouse-snapshot
    (lambda (prev)
      (let* ([x (GetMouseX)]
	     [y (GetMouseY)]
	     [px (if prev (vector2-x (mouse-position prev)) x)]
	     [py (if prev (vector2-y (mouse-position prev)) y)])
	(make-mouse
	 (make-vector2 x y)
	 (make-vector2 (- x px) (- y py))
	 (GetMouseWheelMove)))))

  (define-record-type channel
    (fields volume pan pitch)
    (protocol
     (lambda (new)
       (case-lambda
	 [() (new 1.0 0.0 1.0)]
	 [(v pa pi) (new v pa pi)]))))

  (define-record-type mouse
    (fields
     position offset wheel))
  
  (define-record-type window
    (fields frame channel (mutable delta) (mutable mouse))
    (protocol
     (lambda (new)
       (case-lambda
	 [(fr c d i) (new fr c d i)]
	 [(fr)
	  (new fr (make-channel) 0.0
	       (make-mouse (make-vector2 0 0)
			   (make-vector2 0 0)
			   0))]))))

  (define uptime window-delta)

  (define frame-change-tint
    (lambda (f t)
      (let ([dest (frame-dest f)]
	    [origin (frame-origin f)]
	    [rotation (frame-rotation f)])
	(make-frame dest origin rotation t))))

  (define frame-change-dest
    (lambda (f dest)
      (let ([origin (frame-origin f)]
	    [rotation (frame-rotation f)]
	    [tint (frame-tint f)])
	(make-frame dest origin rotation tint))))

  (define window-change-frame
    (lambda (w f)
      (let ([c (window-channel w)]
	    [d (window-delta w)]
	    [m (window-mouse w)])
	(make-window f c d m))))
  )
