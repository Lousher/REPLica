(library (game engine)
  (export init)
  (import (chezscheme)
	  (game stage)
	  (game color)
	  (game type)
	  (game context)
	  (ffi raylib binding)
	  (ffi rini binding))
  
  (define ANSI-RESET "\x1B;[0m")
  
  (define colored-tracelog-callback
    (lambda (log-level str va-lise)
      (let ([color (case log-level
		     [(0) "\x1B;[90m"]	    ; ALL   - 灰
		     [(1) "\x1B;[90m"]	    ; TRACE - 灰
		     [(2) "\x1B;[36m"]	    ; DEBUG - 青
		     [(3) "\x1B;[32m"]	    ; INFO  - 绿
		     [(4) "\x1B;[33m"]	    ; WARNING - 黄
		     [(5) "\x1B;[31m"]	    ; ERROR - 红
		     [(6) "\x1B;[1;97;41m"] ; FATAL - 白字红底
		     [(7) "\x1B;[37m"]	    ; NONE
		     [else "\x1B;[0m"])])
	(display color)
	(display str)
	(display ANSI-RESET)
	(newline))))

  (define callable-tracelog-callback
    (foreign-callable colored-tracelog-callback
		      (integer-32 string void*)
		      void))

  (define mouse-snapshot
    (lambda (prev)
      (let* ([x (GetMouseX)] [y (GetMouseY)]
	     [px (if prev (vector2-x (mouse-position prev)) x)]
	     [py (if prev (vector2-y (mouse-position prev)) y)])
	(make-mouse (make-vector2 (inexact x) (inexact y))
		    (make-vector2 (inexact (- x px)) (inexact (- y py)))
		    (inexact (GetMouseWheelMove))))))

  (define tick-context
    (lambda (ctx)
      (let* ([m (moment-advance (context-ref ctx MOMENT) (GetFrameTime))]
	     [prev (context-ref-or ctx MOUSE #f)]
	     [mouse (mouse-snapshot prev)])
	(context-set
	 (context-set ctx MOMENT m)
	 MOUSE mouse))))
  
  (define init
    (lambda (config)
      (let* ([ini-cfg (rini_load config)]
	     [title (rini_get_value_text ini-cfg "title")]
	     [w (rini_get_value ini-cfg "width")]
	     [h (rini_get_value ini-cfg "height")]
	     [fps (rini_get_value ini-cfg "fps")])
	(let* ([start-ctx (context-with
			   (make-empty-context)
			   [MOMENT (moment-zero)]
			   [FRAME (make-frame w h)]
			   [CHANNEL (make-channel)])]
	       [C (ftype-alloc Color)])
	  (lambda (s)			; given stage
	    (InitWindow w h title)
	    (InitAudioDevice)
	    (SetTargetFPS fps)
	    (let loop ([ctx start-ctx])
	      (unless (WindowShouldClose)
		(let ([ctx (tick-context ctx)])
		  (BeginDrawing)
		  (ClearBackground (Color<=color black C))
		  ((stage-perform s) ctx)
		  (EndDrawing)
		  (loop ctx))))
	    (CloseAudioDevice)
	    (CloseWindow))))))

  (begin
    (lock-object callable-tracelog-callback)
    (SetTraceLogCallback (foreign-callable-entry-point callable-tracelog-callback))
    (SetTraceLogLevel LOG_WARNING))
  )
