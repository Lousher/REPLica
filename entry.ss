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

(define tex (make-texture "store/asset/store/apartment.morning.png"))
(define mus (make-music "store/asset/store/trip.mp3"))
(define tex2 (make-texture "store/asset/store/apartment.afternoon.png"))
(define rule1 (make-texture "store/asset/wipes/1.png"))
(define sh1 (make-shader #f "store/shaders/dissolve.fs"))
(define bun (make-bundle 1 (list tex tex2 mus sh1 rule1)))

(define pic1 (at
	      (scale (default tex) 2)
	      (lambda (x y) (values (+ x 20) (+ y 100)))))
(define pic2 (scale (default tex2) 0.5))
(define cp1 (plain mus))

(define wipe-fn (shaded sh1 `(("texture1" . ,pic2) ("rule" . ,rule1) ("progress" . 0.0) ("feather" . 0.01))))

(define s-bgm (hold
	       (loop
		(full cp1))))

(define s1 (hold (freeze 0 (still (wipe-fn pic1)))))
(define s1-ani (hold
		(linear 1
			(crossfade (still pic1)
				   (still pic2)))))

(define s1-f (sequential loader s1))

(define s-full (change (clicked? MOUSE_BUTTON_LEFT) s1-f (sequential s-bgm s1-ani)))

(define g (init "config.ini"))

(g (s-full bun))
