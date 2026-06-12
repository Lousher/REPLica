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
	 [white-tex (color->texture white 1 1)]
	 [black-tex (color->texture black 1 1)]
	 [morning-pic (texture->picture morning-tex)]
	 [afternoon-pic (texture->picture afternoon-tex)]
	 [white-pic (texture->picture white-tex)]
	 [black-pic (texture->picture black-tex)]
	 [morning-ani (static morning-pic)]
	 [afternoon-ani (static afternoon-pic)]
	 )
    (animator->stage
     (overlay
      (crossfade morning-pic afternoon-pic 3 ease-in-out-quad)
      (shake
       (spin
	(origin
	 (at
	  (resize (stroke
		   (above 
		    (beside white-pic black-pic 0.5)
		    (beside black-pic white-pic 0.5) 0.5)
		   3 red) 400 400)
	  960 540) 200 200
	  )
	(rate:constant 90))
       10.0 3
       ))
     )))

(yuan main-stage)
