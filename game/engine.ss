(library (game engine)
  (export init)
  (import (chezscheme)
	  (game world)
	  (game stage)
	  (game color)
	  (game type)
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
  
  (define init
    (lambda (config)
      (let* ([ini-cfg (rini_load config)]
	     [title (rini_get_value_text ini-cfg "title")]
	     [w (rini_get_value ini-cfg "width")]
	     [h (rini_get_value ini-cfg "height")]
	     [fps (rini_get_value ini-cfg "fps")])
	(let* ([win-init (make-window w h)]
	       [C (ftype-alloc Color)])
	  (lambda (s)			; given stage
	    (InitWindow w h title)
	    (InitAudioDevice)
	    (SetTargetFPS fps)
	    (let loop ([win win-init])
	      (unless (WindowShouldClose)
		(BeginDrawing)
		(ClearBackground (Color<=color black C))
		((stage-perform s) win)
		(EndDrawing)
		(loop (tick win))))
	    (CloseAudioDevice)
	    (CloseWindow))))))

  (begin
    (lock-object callable-tracelog-callback)
    (SetTraceLogCallback (foreign-callable-entry-point callable-tracelog-callback))
    (SetTraceLogLevel LOG_WARNING))
  )
