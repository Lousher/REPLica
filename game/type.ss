(library (game type)
  (export make-color color Color<=color color<=Color)
  (import (chezscheme)
	  (ffi raylib binding))

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ type)
       (make-ftype-pointer type (foreign-alloc (ftype-sizeof type)))
       ]))

  (define-record-type color
    (fields r g b a))

  (define Color<=color
    (case-lambda
      [(c ptr)
       (ftype-set! Color (r) ptr (color-r c))
       (ftype-set! Color (g) ptr (color-g c))
       (ftype-set! Color (b) ptr (color-b c))
       (ftype-set! Color (a) ptr (color-a c))
       ptr]
      [(c)
       (Color<=color (ftype-alloc Color))]
      ))

  (define color<=Color
    (lambda (C)
      (let ([r (ftype-ref Color (r) C)]
	    [g (ftype-ref Color (g) C)]
	    [b (ftype-ref Color (b) C)]
	    [a (ftype-ref Color (a) C)])
	(make-color r g b a))))
  )
