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

(define make-stage-n
  (lambda (tick ani exit?)
    (let ([BLANK (color->Color blank)])
      (lambda (fr)
	(let loop ()
	  (let ([t (tick (GetTime))])
	    (unless (or (not t) (exit? fr))
	      (load!)
	      (BeginDrawing)
	      (ClearBackground BLANK)
	      ((ani (tick (GetTime))) fr)
	      (EndDrawing)
	      (loop))))
	))))

(define snd-stage
  (let ([tick (loop 5)])
    (lambda (fr)
      ((snd-env (tick (GetTime))) (*CHANNEL*)))))

(define main-menu
  (layer
   menu-pic
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

(define first-sentence
  (anchor-percent
   (resize
    (widthwise
     (centred
      (attach hover?
	      (backdrop
	       (msdf xiaolai-str-pic font-meta)
	       skyblue)
	      snd-stage
	      )))
    #f (lambda (h) (/ h 10)))
   0.5 0.9))

(define second-sentence
  (anchor-percent
   (resize
    (widthwise
     (centred
      (backdrop
       (msdf (string->picture "这是第二个句子啦" font-xiaolai) font-meta)
       skyblue)))
    #f (lambda (h) (/ h 10)))
   0.5 0.9))

(define main-stage
  (lambda (fr)
    (let dispatch ([pc 0])
      (case pc
	[0
	 ((make-stage-n
	   (hold 5)
	   (shake
	    (overlay
	     (letterboxing
	      (picture->animator
	       (layer
		morning-pic
		main-menu))
	      0.5)
	     (picture->animator
	      first-sentence))
	    20)
	   (lambda (fr) (IsMouseButtonPressed MOUSE_BUTTON_LEFT))
	   ) fr)
	 (dispatch (+ pc 1))
	 ]
	[1
	 ((make-stage-n
	   (once 2)
	   (crossfade
	    (picture->animator (letterbox morning-pic 0.5))
	    (picture->animator afternoon-pic))
	   never
	   ) fr)
	 (dispatch (+ pc 1))]
	[2
	 ((make-stage-n
	   (loop (sound-duration snd))
	   (overlay
	    (picture->animator afternoon-pic)
	    (picture->animator second-sentence))
	   (lambda (fr) (WindowShouldClose))
	   ) fr)
	 ]
	))
    ))

(start main-stage)
