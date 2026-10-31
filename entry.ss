(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")
(import (ffi raylib binding))
(import (game engine))
(import (game stage))
(import (game resource))
(import (game picture))
(import (game event))

(define tex (make-texture "store/asset/store/apartment.morning.png"))
(define mus (make-music "store/asset/store/trip.mp3"))
(define tex2 (make-texture "store/asset/store/apartment.afternoon.png"))
(define bun (make-bundle 1 (list tex tex2 mus)))

(define pic1 (default tex))
(define pic2 (default tex2))

(define s1 (static pic1))
(define s2 (static pic2))

					;(define s-final (change (clicked? MOUSE_BUTTON_LEFT) s1 s2))

(define s1-full (sequential loader s1))
(define s2-full (sequential loader s2))

(define s-full (change (clicked? MOUSE_BUTTON_LEFT) s1-full s2-full))

(define g (make-window "config.ini"))

(g (s-full bun))
