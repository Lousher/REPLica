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
  (let* ([aft-tex (load-texture "test/store/apartment.afternoon.png")]
	 [aft-pic (texture->picture aft-tex)]
	 [white-tex (color->texture white 1 1)]
	 [white-pic (texture->picture white-tex)]
	 [msdf-tex (load-texture "assets/xiaolai.msdf.png")]
	 [msdf-pic (texture->picture
		    msdf-tex
		    (make-rectangle
		     3060.5 (- 8548 3724.5)
		     (- 3120.5 3060.5)
		     (- 3724.5 3666.5))
		    )]
	 )
    (animator->stage
     (static (resize (msdf msdf-pic) 200 200))
     )))

(yuan main-stage)
