(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raygui.dynlib")
(import (raylib ffi))
(import (raylib constant))

(define GuiButton
  (foreign-procedure "GuiButton" ((& Rectangle) string) int))

(define GuiMessageBox
  (foreign-procedure "GuiMessageBox" ((& Rectangle) string string string) int))

(define main
  (lambda ()
    (InitWindow 400 200 "raygui - controls test suite")
    (SetTargetFPS 60)
    (let ([showMessageBox #f] [rect-btn (make-Rectangle 24.0 24.0 120.0 30.0)]
	  [rect-box (make-Rectangle 85.0 70.0 250.0 100.0)])
      (let loop ()
	(BeginDrawing)
	(ClearBackground BLANK)
	(when (> (GuiButton rect-btn "Show Message") 0)
	  (set! showMessageBox #t))
	(when showMessageBox
	  (let ([result (GuiMessageBox rect-box "Message Box" "Hi,this is message" "Nice;Cool")])
	    (when (> result 0)
	      (set! showMessageBox #f))))
	(EndDrawing)
	(unless (WindowShouldClose)
	  (loop)))
    (CloseWindow))))
