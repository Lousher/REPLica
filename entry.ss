(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")
(import (ffi raylib binding))
(import (game engine))
(import (game stage))
(import (game resource))
(import (game picture))
(import (game animator))
(import (game clip))
(import (game event))
(import (game ticker))

(define tex (make-texture "store/asset/store/apartment.morning.png"))
(define mus (make-music "store/asset/store/trip.mp3"))
(define tex2 (make-texture "store/asset/store/apartment.afternoon.png"))
(define bun (make-bundle 1 (list tex tex2 mus)))

(define pic1 (default tex))
(define pic2 (default tex2))
(define ani1 (crossfade (still pic1) (still pic2)))
(define cp1 (fade-in mus 3.0))

(define s1-ani (hold (linear ani1 5)))
(define s1 (hold (fade pic1 0.2)))
(define s2 (hold pic2))
(define s3 (hold cp1))

(define s1-full (sequential loader s1-ani))
(define s2-full (sequential loader s2 s3))

					;(define s-full (change (clicked? MOUSE_BUTTON_LEFT) s1-full s2-full))

(define g (init "config.ini"))

(g (s1-full bun))
