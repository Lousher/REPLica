(import (ffi raylib binding))
(load-shared-object "ffi/raylib/libraylib.so.6.2.0")

(define c (make-ftype-pointer Color (foreign-alloc (ftype-sizeof Color))))

(begin
  (InitWindow 600 600 "Test")
  (ftype-set! Color (r) c 0)
  (ftype-set! Color (g) c 255)
  (ftype-set! Color (b) c 255)
  (ftype-set! Color (a) c 255)
  (let loop ()
    (unless (WindowShouldClose)
      (BeginDrawing)
      (ClearBackground c)
      (EndDrawing)
      (loop)))
  (CloseWindow))

