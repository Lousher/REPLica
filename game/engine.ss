(library (game engine)
  (export init)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (ffi raylib binding)
	  (ffi rini binding))

  (define init
    (lambda (config)
      (let* ([ini-cfg (rini_load config)]
	     [title (rini_get_value_text ini-cfg "title")]
	     [w (rini_get_value ini-cfg "width")]
	     [h (rini_get_value ini-cfg "height")]
	     [fps (rini_get_value ini-cfg "fps")])
	(let* ([fr (make-frame w h)]
	       [win-init (make-window fr)])
	  (lambda (s)		; given stage
	    (InitWindow w h title)
	    (InitAudioDevice)
	    (SetTargetFPS fps)
	    (let loop ([win win-init])
	      (unless (WindowShouldClose)
		(BeginDrawing)
		(s win)
		(EndDrawing)
		(loop (tick win))))
	    (CloseAudioDevice)
	    (CloseWindow))))
      ))

  )
