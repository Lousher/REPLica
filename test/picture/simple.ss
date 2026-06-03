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
	   [lena-pic (texture->picture
		      (make-texture
		       "lenna" lena))]
	   [full-fr (make-frame 0.0 0.0 960.0 540.0)]
	   [BLANK (color->Color blank)]
	   )
      (let loop ([width 0.0])
	(unless (WindowShouldClose)
	  (frame-x-set! full-fr width)
	  (BeginDrawing)
	  (ClearBackground BLANK)
	  (lena-pic full-fr)
	  (EndDrawing)
	  (loop (+ width (* 0.1 (GetTime)))))
	)
      (UnloadTexture lena))
    (CloseWindow)))

(main)
