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
(import (game tool))

(alias resource resource-fuzzy-query)

(load-directory ".")

(define rule (above (beside (default (resource 'wipes 2))
			    (default (resource 'wipes 3)))
		    (beside (default (resource 'wipes 4))
			    (default (resource 'wipes 5)))))

(define bgm (linear 3 (plain (dry (resource 'piano 'mp3)))))

(define shaded-ani
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resource 'dissolve 'fs)
	      `(("texture2" . ,(ani2 p)) ("texture1" . ,(ani1 p))
		("rule" . ,rule) ("progress" . ,p) ("feather" . 0.0))))))

(define ani1 (crossfade (still (default (resource 'morning)))
			(still (default (resource 'afternoon)))))

(define ani2 (shaded-ani (still (scale (default (resource 'afternoon)) 2))
			 (still (default (resource 'afternoon)))))

(define mor (default (resource 'morning)))
(define aft (default (resource 'afternoon)))
(define four-matrix-pic (above (beside mor aft)
			       (beside aft mor)))

(define s1 (change (clicked? MOUSE_BUTTON_LEFT)
		   (hold (freeze 0 (still mor)))
		   (hold (linear 2 ani1))))
(define s2 (parallel
	    (hold bgm)
	    (hold (loop 2 ani2))))


(define g (init "config.ini"))

(g s2)
