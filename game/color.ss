(library (game color)
  (export white black blank color->texture
	  color-alpha)
  (import (chezscheme)
	  (ffi raylib binding)
	  (game resource)
	  (game type))

  (define COLOR_TEXTURES (make-hashtable equal-hash equal?))
  
  (define color-alpha
    (lambda (c al)
      (assert (<= 0.0 al 1.0))
      (let ([r (color-r c)]
	    [g (color-g c)]
	    [b (color-b c)]
	    [a (color-a c)])
	(make-color r g b (inexact->exact (round (* a al)))))
      ))

  (define white (make-color 255 255 255 255))
  (define black (make-color 0 0 0 255))
  (define blank (make-color 0 0 0 0))

  (define color->texture
    (let ([C (ftype-alloc Color)])
      (lambda (c)
	(if (hashtable-contains? COLOR_TEXTURES c)
	    (hashtable-ref COLOR_TEXTURES c #f)
	    (let* ([img (GenImageColor 1 1 (Color<=color c C))]
		   [tex (LoadTextureFromImage img)]
		   [c-tex (make-texture "c" tex (make-rectangle 0.0 0.0 1.0 1.0))])
	      (UnloadImage img)
	      (hashtable-set! COLOR_TEXTURES c c-tex)
	      c-tex)))))
  )
