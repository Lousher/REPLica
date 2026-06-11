(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (core animator))
(import (prefix (core rate) rate:))
(import (design color))

(import (ffi raylib binding))

(define main
  (lambda ()
    (InitWindow 1920 1080 "Test")
    (SetTargetFPS 60)
    (let* ([tex (LoadTexture "test/store/apartment.morning.png")]
	   [tex-in (make-texture "lenna" tex)]
	   [pic (texture->picture tex-in)]
	   [fr (make-frame
		1920.0
		1080.0
		(make-vector2 960.0 540.0)
		(make-vector2 960.0 540.0)
		0.0)]
	   [BLANK (color->Color blank)]
	   [ani (shock pic 15 0.3)]
	   )
      (let loop ([a ani])
	(unless (WindowShouldClose)
	  (parameterize ([*PASSED* (GetTime)])
	    (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	      (set! a (shock pic 15 0.3)))
	    (BeginDrawing)
	    (ClearBackground BLANK)
	    (a fr)
	    (EndDrawing)
	    (loop a)))
	)
      (UnloadTexture tex))
    (CloseWindow)))

(main)
