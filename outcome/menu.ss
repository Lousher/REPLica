(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")
(import (ffi raylib binding))
(import (game engine))
(import (game stage))
(import (game resource))
(import (game picture))
(import (game animator))
(import (game clip))
(import (game envelope))
(import (game event))
(import (game ticker))
(import (game fader))
(import (game tool))

(alias resource resource-fuzzy-query)

(load-directory ".")

(define shaded-ani
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resource 'fs 'dissolve) `(("texture2" . ,(ani2 p)) ("texture1" . ,(ani1 p))
		   ("rule" . ,(resource 'wipes 1)) ("progress" . ,p) ("feather" . 0.0))))))

(define ani (crossfade (still (beside
			       (default (resource 'morning))
			       (default (resource 'afternoon))))
		       (still (above
			       (default (resource 'morning))
			       (default (resource 'afternoon))))))

(define s (hold (linear 5 ani)))
(define s2 (hold (backward 5 ani)))
(define s1 (change (clicked? MOUSE_BUTTON_LEFT) s s2))

(define g (init "config.ini"))

(g s1)
