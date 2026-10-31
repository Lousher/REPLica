(library (game picture)
  (export default)
  (import (chezscheme)
	  (game resource) ;texture
	  (game render)
	  (game color))

  (define default
    (lambda (tex)
      (lambda (win) 
	(draw-texture (texture-data tex) 0 0 white))))
  )
