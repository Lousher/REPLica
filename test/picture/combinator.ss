(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (core animator))
(import (prefix (core rate) rate:))
(import (design color))
(import (core easing))

(import (ffi raylib binding))

(define main
  (lambda ()
    (InitWindow 1920 1080 "Test")
    (SetTargetFPS 60)
    (let* ([tex (LoadTexture "test/store/apartment.morning.png")]
	   [tex2 (LoadTexture "test/store/apartment.afternoon.png")]
	   [tex-in (make-texture "morning" tex)]
	   [tex2-in (make-texture "afternoon" tex2)]
	   [pic (texture->picture tex-in)]
	   [pic2 (texture->picture tex2-in)]
	   [fr (make-frame
		1920.0
		1080.0
		(make-vector2 960.0 540.0)
		(make-vector2 960.0 540.0)
		0.0)]
	   [BLANK (color->Color blank)]
	   [ani (static pic)]
	   )
      (let loop ([a ani])
	(unless (WindowShouldClose)
	  (parameterize ([*PASSED* (GetTime)])
	    (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	      (set! a (crossfade
		       (static pic)
		       (static pic2)
		       3
		       ease-in-out-quad)))
	    (BeginDrawing)
	    (ClearBackground BLANK)
	    (a fr)
	    (EndDrawing)
	    (loop a)))
	)
      (UnloadTexture tex))
    (CloseWindow)))

(main)
