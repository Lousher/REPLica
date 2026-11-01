(library (game picture)
  (export default fade composite scale at)
  (import (chezscheme)
	  (game resource) ;texture
	  (game raylib render)
	  (game window)
	  (game type)
	  (game color))

  (define default
    (lambda (tex)
      (lambda (f) ; picture理应只关心frame
	(clear-background black)
	(draw-texture tex f))))

  (define scale
    (lambda (pic times)
      (lambda (f)
	(let ([dest (frame-dest f)])
	  (let-values ([(x y w h) (rectangle-values dest)])
	    (pic (frame-change-dest f (make-rectangle x y (* w times) (* h times)))))))))

  (define at
    (lambda (pic fn-xy)  ;fn-xy 是一个输入x，y返回(values x y)的函数
      (lambda (f)
	(let ([dest (frame-dest f)])
	  (let*-values ([(x y w h) (rectangle-values dest)]
			[(x-new y-new) (fn-xy x y)])
	    (pic (frame-change-dest f (make-rectangle x-new y-new w h))))))))
  
  (define composite
    (lambda pics
      (lambda (f)
	(for-each (lambda (p) (p f)) pics))))

  (define fade
    (lambda (pic alpha)
      (assert (<= 0 alpha 1.0))
      (lambda (f)
	(let* ([t (frame-tint f)])
	  (pic (frame-change-tint f (color-alpha t alpha)))))))
  )
