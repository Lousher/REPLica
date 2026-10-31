(library (game picture)
  (export default elapsed)
  (import (chezscheme)
	  (game resource) ;texture
	  (game raylib render)
	  (game window)
	  (game color))

  (define default
    (lambda (tex)
      (lambda (win) ; 这个win是抽象意义上的win,贴近窗口状态
	(draw-texture tex 0 0 white))))

  (define elapsed
    (lambda (win)
      (draw-text (format "Now has passed ~,2f second" (uptime win)) 0 0 50 white)))

  )
