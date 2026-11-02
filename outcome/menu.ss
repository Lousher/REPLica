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

(define s (hold (linear 2
			(crossfade (still (default (resource 'morning)))
				   (still (default (resource 'afternoon)))))))

(define s-with-loader (sequential loader s))

(define bun (list (resource 'morning)
		  (resource 'afternoon)))

(define g (init "config.ini"))

(g (s-with-loader bun))
