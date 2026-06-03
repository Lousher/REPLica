(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (ffi raylib binding))
(import (core type))
(import (design color))
(import (render resource))
(import (render drawing))

(define main
  (lambda ()
    (InitWindow 960 540 "Test")
    (SetTargetFPS 60)
    (let ([lena (make-asset (LoadTexture "test/ffi/lenna.png"))]
	  [src (make-rectangle 0.0 0.0 250.0 250.0)]
	  [dest (make-rectangle 100.0 100.0 250.0 250.0)]
	  [origin (make-vector2 0.0 0.0)]
	  [BLANK (color->Color blank)]
	  )
      (let loop ()
	(unless (WindowShouldClose)
	  (BeginDrawing)
	  (ClearBackground BLANK)
	  (draw-texture-pro lena src dest origin (* 90 (GetTime)) white)
	  (EndDrawing)
	  (loop))
	)
      (UnloadTexture (asset-pointer lena)))
    (CloseWindow)))

(main)
