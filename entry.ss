(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")
(import (ffi raylib binding))
(import (game engine))
(import (game stage))
(import (game resource))
(import (game event))

(define tex (make-texture "store/asset/store/apartment.morning.png"))
(define mus (make-music "store/asset/store/trip.mp3"))
(define bun (make-bundle 1 (list tex mus)))

(define s (sequential
	   loader
	   (latch (clicked? MOUSE_BUTTON_LEFT) play)
	   static))

(define g (make-window "config.ini"))

(g (s bun))
