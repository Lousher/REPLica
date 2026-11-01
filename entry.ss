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
(define rule2 (make-texture "store/asset/wipes/2.png"))
(define rule3 (make-texture "store/asset/wipes/3.png"))
(define rule4 (make-texture "store/asset/wipes/4.png"))
(define sh1 (make-shader #f "store/shaders/dissolve.fs"))
(define bun (make-bundle 1 (list tex tex2 mus sh1 rule1 rule2 rule3 rule4)))

(define pic1 (default tex))
(define pic2 (default tex2))
(define cp1 (plain mus))
(define rule-pic (above (beside (default rule1)
				(default rule2))
			(beside (default rule3)
				(default rule4))))

(define shaded-ani
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded sh1 `(("texture2" . ,(ani2 p)) ("texture1" . ,(ani1 p))
		    ("rule" . ,rule-pic) ("progress" . ,p) ("feather" . 0.0))))))

(define s-bgm (hold
	       (loop
		(full cp1))))

(define s1 (hold
	    (linear 4 (shaded-ani (still pic1) (still pic2)))))
(define s1-ani (hold
		(linear 1
			(crossfade (still pic2)
				   (still pic1)))))

(define s1-f (sequential loader s1-ani))

(define s-full (change (clicked? MOUSE_BUTTON_LEFT) s1-f (sequential s-bgm s1)))

(define g (init "config.ini"))

(g (s-full bun))
