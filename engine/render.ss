(library (render)
  (export draw)
  (import (chezscheme)
          (raylib ffi)
          (raylib constant)
          (state)
          (scene))
  
  (define draw-texture
    (lambda (node x y scale rotation alpha color)
      (let ([w 100] [h 100])
	(let* ([anchor-x (node-anchor-x node)]
	       [anchor-y (node-anchor-y node)]
	       [origin-x (node-origin-x node)]
	       [origin-y (node-origin-y node)]
	       [anchor-x-offset (* 1920.0 anchor-x)]
	       [anchor-y-offset (* 1080.0 anchor-y)]
	       [origin-x-offset (* width origin-x)]
	       [origin-y-offset (* height origin-y)]
	       [draw-x (- x )])))))
  
  )
