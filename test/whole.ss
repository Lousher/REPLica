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
(define sign-env (gain->envelope (sound->gain (load-sound "../../Store/assets/sound/sign.mp3"))))
(define snd (load-sound "../../Store/assets/va/2.new.ogg"))
(define snd-gain (sound->gain snd))
(define snd-env (gain->envelope snd-gain))

(define file->glyphs
  (lambda (f)
    (call-with-input-file f
      (lambda (p)
	(let loop ([acc '()])
	  (let ([g (read p)])
	    (if (eof-object? g)
		(reverse acc)
		(loop (cons g acc)))))))))

(define glyphs->charmap
  (lambda glys
    (let ([ht (make-hashtable (lambda (x) x) =)])
      (for-each
       (lambda (gly)
	 (hashtable-set! ht (glyph-codepoint gly) gly))
       glys)
      (lambda (key)
	(hashtable-ref ht key #f))
      )
    ))

(define font-tex (load-texture "assets/xiaolai.msdf.png"))
(define font-meta (call-with-input-file "assets/xiaolai.meta.ss" read))
(define font-charmap (apply glyphs->charmap (file->glyphs "assets/xiaolai.msdf.ss")))
(define font-xiaolai (make-font font-meta font-tex font-charmap))
(define xiaolai-str-pic (string->picture "这是一个测试" font-xiaolai))

(define logo-pic (texture->picture (load-texture "assets/logo.png")))
(define white-pic (texture->picture (color->texture white 1 1)))
(define black-pic (texture->picture (color->texture black 1 1)))

(define logo-showing
  (make-stage
   (once 4)
   (concat
    (list
     (crossfade
      (picture->animator black-pic)
      (picture->animator white-pic))
     (overlay
      (picture->animator white-pic)
      (appear (picture->animator logo-pic)))
     (crossfade
      (picture->animator logo-pic)
      (picture->animator black-pic)))
    '(0.25 0.5 0.25)
    )))

(define to-main
  (make-stage
   (once 2)
   (concat
    (list
     (crossfade
      (picture->animator black-pic)
      (picture->animator morning-pic))
     (overlay
      (picture->animator morning-pic)
      (appear (picture->animator menu-pic))))
    '(0.5 0.5))))

(define menu-button
  (lambda (normal chosen target)
    (resize
     (widthwise
      (attach
       (both hover? (mouse-pressed? MOUSE_BUTTON_LEFT))
       (toggle hover? chosen normal)
       (capture target)))
     #f (lambda (h) (/ h 12)))
    ))

(define menu-pic
  (layer
   morning-pic
   menu-pic
   (anchor-percent
    (menu-button
     start-pic
     start-chosen-pic
     'start)
    0.369 0.25)
   (anchor-percent
    (menu-button
     load-pic
     load-chosen-pic
     'load)
    0.369 0.35)
   (anchor-percent
    (menu-button
     config-pic
     config-chosen-pic
     'config)
    0.369 0.45)
   (anchor-percent
    (menu-button
     gallery-pic
     gallery-chosen-pic
     'gallery)
    0.369 0.55)
   (anchor-percent
    (menu-button
     exit-pic
     exit-chosen-pic
     'exit)
    0.369 0.65)))

(define menu-stage
  (captured
   (make-stage
    (loop 10)
    (picture->animator menu-pic))))

(define menu-to-story
  (make-stage
   (once (sound-duration snd))
   (crossfade
    (picture->animator menu-pic)
    (picture->animator black-pic))
   snd-env))

(define main
  (case-lambda
    [(fr)
     (let dispatch ([pc 'logo])
       (case pc
	 [(logo)
	  ((eternal (ready logo-showing) never) fr)
	  (dispatch 'trans)]
	 [(trans)
	  ((eternal (ready to-main) never) fr)
	  (dispatch 'menu)]
	 [(menu)
	  ((eternal (ready menu-stage)
		    (lambda (fr)
		      (let-values ([(p s) (menu-stage)])
			(eqv? s 'start)))) fr)
	  (dispatch 'start)]
	 [(start)
	  ((eternal (ready menu-to-story)
		    (lambda (fr) (WindowShouldClose)))
	   fr)]))
     ]
    [() (values 1.0 #t)]))

(start main)
