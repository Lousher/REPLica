(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (core animator))
(import (core ticker))
(import (prefix (core rate) rate:))
(import (design color))
(import (core easing))
(import (engine game))
(import (engine stage))
(import (engine loader))
(import (core layout))
(import (engine event))

(import (ffi raylib binding))

(define yuan (make-game "Yuan" 1920 1080))

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

(define main-stage
  (let* ([mor-tex (load-texture "test/store/apartment.morning.png")]
	 [mor-pic (texture->picture mor-tex)]
	 [aft-tex (load-texture "test/store/apartment.afternoon.png")]
	 [aft-pic (texture->picture aft-tex)]
	 [mask-tex (load-texture "assets/wipes/11.png")]
	 [mask-pic (texture->picture mask-tex)]
	 [red-linear-tex (linear-color->texture
			  (make-color 255 255 150 255)
			  (make-color 255 230 80 255)
			  240 80 -90)]
	 [blue-linear-tex (linear-color->texture
			   (make-color 0 242 254 255)
			   (make-color 79 172 254 255)
			   240 80 -90)]
	 [red-linear-pic (texture->picture red-linear-tex)]
	 [blue-linear-pic (texture->picture blue-linear-tex)]
	 [white-tex (color->texture white 1 1)]
	 [black-tex (color->texture black 1 1)]
	 [white-pic (texture->picture white-tex)]
	 [black-pic (texture->picture black-tex)]
	 [msdf-tex (load-texture "assets/xiaolai.msdf.png")]
	 [msdf-meta (call-with-input-file "assets/xiaolai.meta.ss" read)]
	 [msdf-charpmap (apply glyphs->charmap (file->glyphs "assets/xiaolai.msdf.ss"))]
	 [xiaolai (make-font msdf-meta msdf-tex msdf-charpmap)]
	 [aft-ani (picture->animator aft-pic)]
	 [mor-ani (picture->animator mor-pic)]
	 [str-pic (resize
		   (widthwise
		    (msdf (string->picture "这可真是够了" xiaolai)
			  msdf-meta))
		   #f
		   (lambda (h) (/ h 10)))]
	 [tab-sized (lambda (pic)
		      (resize
		       (origin-right pic)
		       (lambda (w) (* w 240/1920 12/5))
		       (lambda (h) (* h 80/1080))))]
	 )
    (eternal
     (ready
      (ensemble
       (make-stage
	(loop 10)
	(picture->animator mor-pic))
       (resize
	(make-stage
	 (loop 10)
	 (picture->animator
	  (layer white-pic
		 (anchor-right
		  (layer
		   (at (tab-sized
			(toggle
			 (both hover? (mouse-down? MOUSE_BUTTON_LEFT))
			 red-linear-pic
			 blue-linear-pic))
		       #f (lambda (y) (+ y 200)))
		   (at (tab-sized blue-linear-pic)
		       #f (lambda (y) (+ y 300)))
		   (at (tab-sized blue-linear-pic)
		       #f (lambda (y) (+ y 400)))
		   (at (tab-sized blue-linear-pic)
		       #f (lambda (y) (+ y 500)))
		   (at (tab-sized blue-linear-pic)
		       #f (lambda (y) (+ y 600)))
		   )))))
	(lambda (w) (* w 5/12))
	#f)
       ))
     (lambda (fr)
       (WindowShouldClose)))
    ))

(yuan main-stage)

