(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (core animator))
(import (prefix (core rate) rate:))
(import (design color))
(import (core easing))
(import (engine game))
(import (engine stage))
(import (engine loader))

(import (ffi raylib binding))

(define yuan (make-game "Yuan" 1920 1080))

(define main-stage
  (let* ([morning-tex (load-texture "test/store/apartment.morning.png")]
	 [afternoon-tex (load-texture "test/store/apartment.afternoon.png")]
	 [morning-pic (texture->picture morning-tex)]
	 [afternoon-pic (texture->picture afternoon-tex)]
	 [morning-ani (static morning-pic)]
	 [afternoon-ani (static afternoon-pic)])
    (animator->stage
     (crossfade morning-ani afternoon-ani 5 ease-in-out-quad))))

(yuan main-stage)
