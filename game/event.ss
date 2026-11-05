(library (game event)
  (export clicked? hovered?)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (ffi raylib binding))

  (define point-in-rectangle?
    (lambda (p rect)
      (let-values ([(px py) (vector2-values p)]
		   [(rx ry rw rh) (rectangle-values rect)])
	(and (>= px rx) (< px (+ rx rw))
	     (>= py ry) (< py (+ ry rh))))))
  
  #| event 是一个输入 条件，与起始状态，满足条件后会改变输出状态的函数 |#
  (define hovered?
    (lambda (win)
      (let* ([mouse-pos (mouse-position (window-mouse win))]
	     [f (window-frame win)]
	     [dest (frame-dest f)])
	(point-in-rectangle? mouse-pos dest))))
  
  (define clicked?
    (lambda (key)
      (lambda (win)
	(let* ([mouse-pos (GetMousePosition)]
	       [f (window-frame win)]
	       [dest (frame-dest f)])
	  (and (hovered? win)
	       (IsMouseButtonPressed key))))))

  )
