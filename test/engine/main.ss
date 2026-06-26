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
	 [str-ani (picture->animator (resize
				      (widthwise
				       (msdf (string->picture "This is hello world" xiaolai)
					     msdf-meta))
				      #f
				      (lambda (h) (/ h 10))))]
	 )
    (animator->stage
     (yoyo 3 linear
	   (dissolve (spin (shake (overlay
				   aft-ani
				   str-ani) 15) 45)
		     "assets/wipes/11.png"))
     #|(unfurl
     (resize				; ; ; ;
     (at				; ; ; ;
     (widthwise				; ; ; ;
     (centred				; ; ; ;
     (backdrop				; ; ; ;
     (msdf				; ; ; ;
     (string->picture "This is a very long long long text for testing, you simply don't know" xiaolai) ; ; ; ;
     msdf-meta)				; ; ; ;
     darkgray)))			; ; ; ;
     (lambda (x) 960.0)			; ; ; ;
     (lambda (y) 540.0))		; ; ; ;
     #f (lambda (h) (/ h 10)))		; ; ; ;
     3 linear)|#)))

(yuan main-stage)

