(load-shared-object "ffi/raylib/libraylib.so.6.0.0")
(import (ffi raylib binding))
(import (engine game))
(import (engine loader))
(import (core picture))
(import (core animator))
(import (core ticker))
(import (engine stage))
(import (engine event))

(import (core type))
(import (core layout))
(import (core behavior))
(import (design color))
(import (core channel))
(import (core gain))
(import (core envelope))

(define start (make-game "Test" 1920 1080))

(define morning-pic (texture->picture (load-texture "test/store/apartment.morning.png")))
(define morning-ani (shake (picture->animator morning-pic) 15))

(define afternoon-pic (texture->picture (load-texture "test/store/apartment.afternoon.png")))

(define menu-pic (texture->picture (load-texture "../../Store/assets/menu/main2x.png")))
(define start-pic (texture->picture (load-texture "../../Store/assets/menu/button/start.png")))
(define load-pic (texture->picture (load-texture "../../Store/assets/menu/button/load.png")))
(define config-pic (texture->picture (load-texture "../../Store/assets/menu/button/config.png")))
(define gallery-pic (texture->picture (load-texture "../../Store/assets/menu/button/gallery.png")))
(define exit-pic (texture->picture (load-texture "../../Store/assets/menu/button/exit.png")))

(define start-chosen-pic (texture->picture (load-texture "../../Store/assets/menu/button/start.chosen.png")))
(define load-chosen-pic (texture->picture (load-texture "../../Store/assets/menu/button/load.chosen.png")))
(define config-chosen-pic (texture->picture (load-texture "../../Store/assets/menu/button/config.chosen.png")))
(define gallery-chosen-pic (texture->picture (load-texture "../../Store/assets/menu/button/gallery.chosen.png")))
(define exit-chosen-pic (texture->picture (load-texture "../../Store/assets/menu/button/exit.chosen.png")))

(define black-pic (texture->picture (color->texture black 1 1)))

(define afternoon-ani (spin (picture->animator afternoon-pic) 45))
(define snd (load-sound "../../Store/assets/va/2.new.ogg"))
(define snd-gain (sound->gain snd))
(define snd-env (crossing (gain->envelope snd-gain)))


(define make-stage-n
  (lambda (tick ani exit?)
    (lambda (fr)
      (let loop ()
	(unless (exit? fr)
	  (load!)
	  (BeginDrawing)
	  ((ani (tick (GetTime))) fr)
	  (EndDrawing)
	  (loop)))
      )))

(define main-menu
  (layer
   morning-pic
   ;   menu-pic
   (resize
    (layer
     (toggle hover? start-chosen-pic start-pic)
     (at
      (toggle hover? load-chosen-pic load-pic)
      #f (lambda (y) (+ y 100)))
     (at
      (toggle hover? config-chosen-pic config-pic)
      #f (lambda (y) (+ y 200)))
     (at
      (toggle hover? gallery-chosen-pic	gallery-pic)
      #f (lambda (y) (+ y 300)))
     (at
      (toggle hover? exit-chosen-pic exit-pic)
      #f (lambda (y) (+ y 400))))
    (lambda (w) (/ w 12))
    (lambda (h) (/ h 15)))
   ))

(define main-stage
  (lambda (fr)
    (let dispatch ([pc 'main])
      (case pc
	[(main)
	 ((make-stage-n
	   (once (* 2.5 (sound-duration snd)))
	   (lambda (progress)
	     ((snd-env progress) (*CHANNEL*))
	     main-menu
	     )
	   (lambda (fr) (WindowShouldClose))
	   ) fr)
	 ]
	))
    ))

(start main-stage)
