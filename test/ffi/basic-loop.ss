(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (ffi raylib binding))

(define main
  (lambda ()
    (InitWindow 960 540 "Test")
    (let loop ()
      (unless (WindowShouldClose)
	(BeginDrawing)
	(EndDrawing)
	(loop))
      )
    (CloseWindow)))

(main)
