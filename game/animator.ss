(library (game animator)
  (export still crossfade motivate)
  (import (chezscheme)
	  (game picture))
  
  #| animator 是一个根据 progress （0-1） 返回 picture的函数 |#
  (define still				; 最简单的动画是静止的图画
    (lambda (pic)
      (lambda (p) pic)))
  
  (define crossfade
    (lambda (ani1 ani2)
      (lambda (p)
	(composite
	 (fade (ani1 p) (max (- 1 p) 0))
	 (fade (ani2 p) (min 1 p))))))

  (define motivate
    (lambda (ani mot)
      (lambda (p)
	(at (ani p) (mot p))))) ; mot -> p -> (values x y)q
  )
