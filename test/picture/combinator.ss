(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (design color))

(import (ffi raylib binding))

(define main
  (lambda ()
    (InitWindow 960 540 "Test")
    (SetTargetFPS 60)
    (let* ([lena (LoadTexture "test/ffi/lenna.png")]
	   [tex-in (make-texture "lenna" lena)]
	   [lena-pic (texture->picture tex-in)]
	   [final-pic (beside (above
			       lena-pic lena-pic 0.5)
			      (above lena-pic lena-pic 0.5)
			      0.5)]
	   [fr (make-frame
		250.0 250.0
		(make-vector2 125.0 125.0)
		(make-vector2 125.0 125.0)
		0.0)]
	   [BLANK (color->Color blank)]
	   )
      (let loop ()
	(unless (WindowShouldClose)
	  (BeginDrawing)
	  (ClearBackground BLANK)
	  (final-pic fr)
	  (EndDrawing)
	  (loop))
	)
      (UnloadTexture lena))
    (CloseWindow)))

(main)
