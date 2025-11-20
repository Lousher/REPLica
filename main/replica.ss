(library (replica)
  (export replica)
  (import (raylib ffi)
	  (raylib constant)
	  (chezscheme))

  (define replica
    (lambda ()
      (InitWindow 800 600 "text")
      (let loop ()
	(BeginDrawing)
	(ClearBackground BLACK)
	(EndDrawing)
	(unless (WindowShouldClose)
	  (loop)))
      (CloseWindow)))
  )

