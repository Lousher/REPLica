(library (game fader)
  (export loop)
  (import (chezscheme)
	  (game window))

  #| envelope |#
  (define loop
    (lambda (ev)
      (lambda (win)
	(let ([cp (ev 0)])
	  (cp (window-channel win))))))
  )
