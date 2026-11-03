(library (game fader)
  (export loop)
  (import (chezscheme)
	  (game window)
	  (game clip))

  #| envelope |#
  (define loop
    (lambda (ev)
      (let* ([cp (ev 0)]
	     [player (clip-player cp)])
	(lambda (win)
	  (player (window-channel win))
	  (clip-deps cp)))))
  )
