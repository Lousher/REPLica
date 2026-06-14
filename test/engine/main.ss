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
	 [sdf-bv (call-with-port (open-file-input-port "assets/xiaolai.bin" (file-options no-fail) (buffer-mode block) #f)
		   get-bytevector-all)]
	 [glyphs (call-with-port (open-file-input-port "assets/xiaolai.bin" (file-options no-fail) (buffer-mode block) #f)
		   fasl-read)]
	 [glyph (glyph-coord (list-ref glyphs 5))]
	 )
    (animator->stage
     (spin
      (at
       (resize (tint aft-pic darkgray) 500 500)
       960 540
       ) (rate:constant 90))
     )))

(yuan main-stage)
