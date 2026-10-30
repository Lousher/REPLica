(library (game event)
  (export clicked?)
  (import (chezscheme)
	  (ffi raylib binding))

  #| event 是一个输入 条件，与起始状态，满足条件后会改变输出状态的函数 |#
  (define clicked?
    (lambda (key)
      (lambda ()
	(IsMouseButtonPressed key))))
  )
