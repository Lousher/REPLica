(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")
(import (game engine))
(import (game stage))
(import (game resource))

(define tex (make-texture "store/asset/store/apartment.morning.png"))
(define bun (make-bundle 1 (list tex)))
(define s (sequential loader static))

(define g (make-window "config.ini"))

(g (s bun))
