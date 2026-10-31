(library (game picture)
  (export default fade composite)
  (import (chezscheme)
	  (game resource) ;texture
	  (game raylib render)
	  (game window)
	  (game color))

  (define default
    (lambda (tex)
      (lambda (f) ; picture理应只关心frame
	(let*([tint (frame-tint f)])
	  (draw-texture tex 0 0 tint)))))

  (define composite
    (lambda pics
      (lambda (f)
	(for-each (lambda (p) (p f)) pics))))

  (define fade
    (lambda (pic alpha)
      (assert (<= 0 alpha 255))
      (lambda (f)
	(let* ([t (frame-tint f)])
	  (pic (frame-change-tint f (color-alpha t alpha)))))))
  )
