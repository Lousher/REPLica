(library (game event)
  (export clicked? hovered?)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (ffi raylib binding))

  #| event 是一个输入 条件，与起始状态，满足条件后会改变输出状态的函数 |#
  (define hovered?
    (let ([RECT (ftype-alloc Rectangle)])
      (lambda (win)
	(let* ([mouse-pos (GetMousePosition)]
	       [f (window-frame win)]
	       [dest (frame-dest f)])
	  (let ([res (CheckCollisionPointRec mouse-pos (Rectangle<=rectangle dest RECT))])
	    (TraceLog LOG_WARNING (format "[Event] Hovered status ~a, ~a, ~a" res dest (vector2<=Vector2 mouse-pos)))
	    res)))))
  
  (define clicked?
    (let ([RECT (ftype-alloc Rectangle)])
      (lambda (key)
	(lambda (win)
	  (let* ([mouse-pos (GetMousePosition)]
		 [f (window-frame win)]
		 [dest (frame-dest f)])
	    (and (hovered? win)
		 (IsMouseButtonPressed key)))))))

  )
