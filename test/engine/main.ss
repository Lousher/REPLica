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

(define string->picture
  (lambda (str meta tex charmap)
    (let ([size (atlas-size (font-meta-atlas meta))]
	  [asc (metrics-ascender (font-meta-metrics meta))])
      (let loop ([pics '()] [chars (string->list str)]
		 [x 0.0])
	(if (null? chars)
	    (apply layer (reverse pics))
	    (let* ([ch (car chars)]
		   [gly (charmap (char->integer ch))]
		   [ple (glyph-plane gly)]
		   [left (plane-left ple)]
		   [right (plane-right ple)]
		   [bottom (plane-bottom ple)]
		   [top (plane-top ple)]
		   [pos-x (+ x (* size left))]
		   [pos-y (* size bottom)])
	      (loop (cons
		     (at
		      (scale 
		       (texture->picture
			tex (glyph-coord gly))
		       (- right left)
		       (- top bottom)
		       )
		      pos-x pos-y)
		     pics)
		    (cdr chars)
		    (+ x
		       (* size
			  (glyph-advance gly))))))))))

(define main-stage
  (let* ([aft-tex (load-texture "test/store/apartment.afternoon.png")]
	 [aft-pic (texture->picture aft-tex)]
	 [white-tex (color->texture white 1 1)]
	 [white-pic (texture->picture white-tex)]
	 [msdf-tex (load-texture "assets/xiaolai.msdf.png")]
	 [msdf-meta (call-with-input-file "assets/xiaolai.meta.ss" read)]
	 [msdf-charpmap (apply glyphs->charmap (file->glyphs "assets/xiaolai.msdf.ss"))]
	 [str-pic (string->picture "The quick brown fox jumps over the lazy dog." msdf-meta msdf-tex msdf-charpmap)]
	 )
    (animator->stage
     (static
      (at
       (resize
	(msdf str-pic msdf-meta)
	(atlas-size (font-meta-atlas msdf-meta))
	(atlas-size (font-meta-atlas msdf-meta)))
       0 100))
     )))

(yuan main-stage)
