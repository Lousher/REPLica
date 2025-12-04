(library (state)
  (export state-init)
  (import (chezscheme)
	  (raylib ffi))

  (define state-init
    (lambda ()
      `((:global . (
		    (:window . ((:x . 0) (:y . 0) (:width . ,(GetScreenWidth)) (:height . ,(GetScreenHeight))))
		    (:time . 0.0)
		    ))
	(:local . ()))))

  )
