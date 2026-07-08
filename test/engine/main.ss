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
	 
	 )
    (eternal
     (sequential
      (list
       (make-stage
	(yoyo 1)
	(ease
	 (spin (picture->animator mor-pic)
	       45)
	 ease-in-cubic))
       )
      (lambda (fr) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))
     (lambda (fr)
       (WindowShouldClose)))
    ))

(yuan main-stage)

