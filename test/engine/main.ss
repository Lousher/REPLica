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

(define char->texture
  (lambda (ch font)
    (let* ([cp (char->integer ch)]
	   [meta (font-metadata font)]
	   [sprite (font-sprite font)]
	   [charmap (font-charmap font)]
	   [size (atlas-size (font-meta-atlas meta))]
	   [asc (metrics-ascender (font-meta-metrics meta))]
	   [gly (charmap cp)]
	   [ple (glyph-plane gly)])
      (let* ([ple (glyph-plane gly)]
	     [left (plane-left ple)]
	     [right (plane-right ple)]
	     [bottom (plane-bottom ple)]
	     [top (plane-top ple)]
	     [pos-x (* size left)]
	     [pos-y (- (* size bottom) (* size asc))])
	(at
	 (scale 
	  (texture->picture
	   sprite (glyph-coord gly))
	  (- right left)
	  (- top bottom))
	 pos-x pos-y)
	))))

(define load-font
  (lambda (meta tex charmap)
    (let ([size (atlas-size (font-meta-atlas meta))]
	  [asc (metrics-ascender (font-meta-metrics meta))])
      (lambda (str)
	(let-values ([(char-pics xs)
		      (let loop ([pics '()]
				 [chars (string->list str)]
				 [xs '()])
			(if (null? chars)
			    (values
			     (reverse pics)
			     (reverse xs))
			    (let* ([ch (car chars)]
				   [x (if (null? xs) 0.0 (car xs))]
				   [gly (charmap (char->integer ch))]
				   [ple (glyph-plane gly)]
				   [left (plane-left ple)]
				   [right (plane-right ple)]
				   [bottom (plane-bottom ple)]
				   [top (plane-top ple)]
				   [pos-x (+ x (* size left))]
				   [pos-y (- (* size bottom) (* size asc))])
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
				    (cons 
				     (+ x
					(* size
					   (glyph-advance gly)))
				     xs)))))])
	  (lambda (fr)
	    (let* ([width (frame-width fr)]
		   [height (frame-height fr)]
		   [acr (frame-anchor fr)]
		   [ori (frame-origin fr)]
		   [rot (frame-rotation fr)]
		   [ori-x (vector2-x ori)]
		   [ori-y (vector2-y ori)])
	      (let* ([ws (let cal ([poss xs] [res '()])
			   (if (null? (cdr poss))
			       (cons (car xs) (reverse res))
			       (cal
				(cdr poss)
				(cons (- (cadr poss) (car poss)) res))))]
		     [frs (map
			   (lambda (x w)
			     (make-frame
			      w (inexact size)
			      acr (make-vector2 x ori-y)
			      rot
			      ))
			   (cons 0.0
				 (reverse (cdr (reverse xs)))) ws)])
		(for-each
		 (lambda (pic f)
		   (pic f))
		 char-pics
		 frs
		 )))))
	))))

(define main-stage
  (let* ([aft-tex (load-texture "test/store/apartment.afternoon.png")]
	 [aft-pic (texture->picture aft-tex)]
	 [white-tex (color->texture white 1 1)]
	 [black-tex (color->texture black 1 1)]
	 [white-pic (texture->picture white-tex)]
	 [black-pic (texture->picture black-tex)]
	 [msdf-tex (load-texture "assets/xiaolai.msdf.png")]
	 [msdf-meta (call-with-input-file "assets/xiaolai.meta.ss" read)]
	 [msdf-charpmap (apply glyphs->charmap (file->glyphs "assets/xiaolai.msdf.ss"))]
	 [xiaolai (make-font msdf-meta msdf-tex msdf-charpmap)]
	 )
    (animator->stage
     (overlay
      (static
       (resize aft-pic (lambda (x) 100) (lambda (y) 100))
       )
      )
     )))

(yuan main-stage)
