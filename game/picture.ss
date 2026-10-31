(library (game picture)
  (export default)
  (import (chezscheme)
	  (game resource) ;texture
	  (game raylib render)
	  (game color))

  (define default
    (lambda (tex)
      (lambda (win) ; 这个win是抽象意义上的win,贴近窗口状态
	(draw-texture tex 0 0 white))))
  )
