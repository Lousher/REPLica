(library (game window)
  (export 
   make-timeline timeline? timeline-uptime timeline-uptime-set!
   make-window window?
   window-timeline window-frame window-mouse window-channel
   uptime
   make-frame
   frame? frame-dest frame-origin frame-rotation frame-tint
   mouse-position
   channel? channel-volume channel-pan channel-pitch
   
   frame-change-tint frame-change-dest
   window-change-frame
   tick tick-time tick-input)
  (import (chezscheme)
	  (ffi raylib binding)
	  (game type)
	  (game color))

  (define-record-type timeline
    (fields (mutable uptime))
    (protocol
     (lambda (new)
       (case-lambda
	 [() (new 0.0)]
	 [(t) (new t)]))))

  (define-record-type frame
    (fields dest origin rotation tint)
    (protocol
     (lambda (new)
       (case-lambda
	 [(d o r t) (new d o r t)]
	 [(w h)
	  (new (make-rectangle 0.0 0.0 (inexact w) (inexact h))
	       (make-vector2 0.0 0.0)
	       0 white)]))))

  (define-record-type mouse
    (fields position offset wheel))

  (define-record-type channel
    (fields volume pan pitch)
    (protocol
     (lambda (new)
       (case-lambda
	 [() (new 1.0 0.0 1.0)]
	 [(v pa pi) (new v pa pi)]))))

  (define-record-type window
    (fields timeline
	    frame
	    (mutable mouse)
	    channel)
    (protocol
     (lambda (new)
       (case-lambda
	 [(w h)
	  (new (make-timeline)
	       (make-frame w h)
	       (make-mouse (make-vector2 0 0) (make-vector2 0 0) 0)
	       (make-channel))]
	 [(t f m c) (new t f m c)]))))

  (define (uptime win)
    (timeline-uptime (window-timeline win)))

  (define (frame-change-tint f t)
    (make-frame (frame-dest f) (frame-origin f) (frame-rotation f) t))

  (define (frame-change-dest f dest)
    (make-frame dest (frame-origin f) (frame-rotation f) (frame-tint f)))

  (define (window-change-frame win new-frame)
    (make-window (window-timeline win)
		  new-frame
		  (window-mouse win)
		  (window-channel win)))

  (define (tick-time win)
    (timeline-uptime-set! (window-timeline win)
			  (+ (uptime win) (GetFrameTime)))
    win)

  (define (mouse-snapshot prev)
    (let* ([x (GetMouseX)] [y (GetMouseY)]
	   [px (if prev (vector2-x (mouse-position prev)) x)]
	   [py (if prev (vector2-y (mouse-position prev)) y)])
      (make-mouse (make-vector2 x y)
		  (make-vector2 (- x px) (- y py))
		  (GetMouseWheelMove))))

  (define (tick-input win)
    (make-window (window-timeline win)
		  (window-frame win)
		  (mouse-snapshot (window-mouse win))
		  (window-channel win)))

  ;; 兼容旧的 tick
  (define (tick win)
    (tick-input (tick-time win)))
  )
