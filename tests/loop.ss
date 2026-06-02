(import (raylib ffi))
(import (raylib constant))

(define main
  (lambda ()
    (InitWindow 1920 1080 "Loop for Test")
    (InitAudioDevice)
    (let loop ()
      (unless (WindowShouldClose)
	(BeginDrawing)
	(ClearBackground BLACK)

	(EndDrawing)
	(loop)))
    (CloseAudioDevice)
    (CloseWindow)))
