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

(define rule (above (beside (default (resource 'wipes 2))
			    (default (resource 'wipes 3)))
		    (beside (default (resource 'wipes 4))
			    (default (resource 'wipes 5)))))

(define shaded-ani
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resource 'dissolve 'fs) `(("texture2" . ,(ani2 p)) ("texture1" . ,(ani1 p))
					 ("rule" . ,(default (resource 'wipes 7))) ("progress" . ,p) ("feather" . 0.0))))))

(define ani (crossfade (still (default (resource 'morning)))
			(still (default (resource 'afternoon)))))

(define s (hold (linear 1 ani)))
(define s2 (hold (backward 1 ani)))
(define s1 (change (clicked? MOUSE_BUTTON_LEFT) s s2))

(define g (init "config.ini"))

(g s1)
