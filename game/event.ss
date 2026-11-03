(library (game event)
  (export clicked?)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (ffi raylib binding))

  #| event 是一个输入 条件，与起始状态，满足条件后会改变输出状态的函数 |#

  (define clicked?
    (let ([RECT (ftype-alloc Rectangle)])
      (lambda (key)
	(lambda (win)
	  (let* ([mouse-pos (GetMousePosition)]
		 [f (window-frame win)]
		 [dest (frame-dest f)])
	    (and (CheckCollisionPointRec mouse-pos (Rectangle<=rectangle dest RECT))
		 (IsMouseButtonPressed key)))))))
  )
