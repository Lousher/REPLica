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
	   [fr (make-frame
		(texture-width tex-in)
		(texture-height tex-in)
		(make-vector2 (/ (texture-width tex-in) 2)
			      (/ (texture-height tex-in) 2))
		(make-vector2 (/ (texture-width tex-in) 2)
			      (/ (texture-height tex-in) 2))
		90.0)]
	   [BLANK (color->Color blank)]
	   )
      (let loop ([width 0.0])
	(unless (WindowShouldClose)
	  (BeginDrawing)
	  (ClearBackground BLANK)
	  (lena-pic fr)
	  (EndDrawing)
	  (loop (+ width (* 0.1 (GetTime)))))
	)
      (UnloadTexture lena))
    (CloseWindow)))

(main)
