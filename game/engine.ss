(library (game engine)
  (export make-window)
  (import (chezscheme)
	  (ffi raylib binding)
	  (ffi rini binding))

  (define make-window
    (lambda (config)
      (let* ([ini-cfg (rini_load config)]
	     [title (rini_get_value_text ini-cfg "title")]
	     [w (rini_get_value ini-cfg "width")]
	     [h (rini_get_value ini-cfg "height")])
	(lambda (s) ; given stage
	  (InitWindow w h title)
	  (InitAudioDevice)
	  (SetTargetFPS 60)
	  (let loop ()
	    (unless (WindowShouldClose)
	      (BeginDrawing)
	      (s)
	      (EndDrawing)
	      (loop)))
	  (CloseAudioDevice)
	  (CloseWindow)))))
  )
