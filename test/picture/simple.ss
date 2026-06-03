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
	   [fr (texture->frame tex-in 100.0 100.0 0.0)]
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
