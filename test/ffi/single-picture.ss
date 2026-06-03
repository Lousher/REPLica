(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (ffi raylib binding))
(import (core type))
(import (design color))

(define main
  (lambda ()
    (InitWindow 960 540 "Test")
    (let ([lena (LoadTexture "test/ffi/lenna.png")]
	  [BLANK (color->Color blank)]
	  [WHITE (color->Color white)])
      (let loop ()
	(unless (WindowShouldClose)
	  (BeginDrawing)
	  (ClearBackground BLANK)
	  (DrawTexture lena 100 100 WHITE)
	  (EndDrawing)
	  (loop))
	)
      (UnloadTexture lena))
    (CloseWindow)))

(main)
