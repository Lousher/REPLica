(library (core type)
  (export
   make-color color->Color Color->color color?
   color-r color-g color-b color-a
   make-vector2 vector2->Vector2 Vector2->vector2 vector2?
   vector2-x vector2-y
   make-rectangle rectangle->Rectangle Rectangle->rectangle rectangle?
   rectangle-x rectangle-y rectangle-width rectangle-height
   make-texture texture?
   texture-name texture-pointer texture-source texture-source-set!
   texture-origin texture-origin-set! texture-tint texture-tint-set!
   texture-width texture-height
   )
  (import
   (chezscheme)
   (only (ffi raylib binding) Color Rectangle Vector2 Texture2D)
   )

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ ftype)
       (make-ftype-pointer ftype (foreign-alloc (ftype-sizeof ftype)))]))  
  
  (define-record-type rectangle
    (fields
     (immutable x)
     (immutable y)
     (immutable width)
     (immutable height))
    (protocol
     (lambda (new)
       (lambda (x y w h)
	 (assert (for-all flonum? (list x y w h)))
	 (new x y w h)))))

  (define rectangle->Rectangle
    (case-lambda
      [(rect fptr)
       (assert (rectangle? rect))
       (ftype-set! Rectangle (x) fptr (rectangle-x rect))
       (ftype-set! Rectangle (y) fptr (rectangle-y rect))
       (ftype-set! Rectangle (width) fptr (rectangle-width rect))
       (ftype-set! Rectangle (height) fptr (rectangle-height rect))
       fptr]
      [(rect)
       (rectangle->Rectangle rect (ftype-alloc Rectangle))])
    )

  (define Rectangle->rectangle
    (lambda (Rect)
      (assert (ftype-pointer? Rect))
      (let ([x (ftype-ref Rectangle (x) Rect)]
	    [y (ftype-ref Rectangle (y) Rect)]
	    [w (ftype-ref Rectangle (width) Rect)]
	    [h (ftype-ref Rectangle (height) Rect)])
	(make-rectangle x y w h))
      )
    )

  (define-record-type vector2
    (fields
     (immutable x)
     (immutable y)
     )
    (protocol
     (lambda (new)
       (lambda (x y)
	 (assert (for-all flonum? (list x y)))
	 (new x y)))))

  (define vector2->Vector2
    (case-lambda
      [(vec2 fptr)
       (assert (vector2? vec2))
       (ftype-set! Vector2 (x) fptr (vector2-x vec2))
       (ftype-set! Vector2 (y) fptr (vector2-y vec2))
       fptr]
      [(vec2)
       (vector2->Vector2 vec2 (ftype-alloc Vector2))])
    )

  (define Vector2->vector2
    (lambda (Vec2)
      (assert (ftype-pointer? Vec2))
      (let ([x (ftype-ref Vector2 (x) Vec2)]
	    [y (ftype-ref Vector2 (y) Vec2)])
	(make-vector2 x y))))

  (define uint8?
    (lambda (x)
      (and (fixnum? x)
	   (<= 0 x 255))))

  (define-record-type color
    (fields
     (immutable r)
     (immutable g)
     (immutable b)
     (immutable a))
    (protocol
     (lambda (new)
       (lambda (r g b a)
	 (assert (for-all uint8? (list r g b a)))
	 (new r g b a)))))

  (define color->Color
    (case-lambda
      [(c fptr)
       (assert (color? c))
       (ftype-set! Color (r) fptr (color-r c))
       (ftype-set! Color (g) fptr (color-g c))
       (ftype-set! Color (b) fptr (color-b c))
       (ftype-set! Color (a) fptr (color-a c))
       fptr]
      [(c)
       (color->Color c (ftype-alloc Color))])
    )

  (define Color->color
    (lambda (C)
      (assert (ftype-pointer? C)) ;Not accurate
      (let ([r (ftype-ref Color (r) C)]
	    [g (ftype-ref Color (g) C)]
	    [b (ftype-ref Color (b) C)]
	    [a (ftype-ref Color (a) C)])
	(make-color r g b a)))
    )

  (define-record-type texture
    (fields
     (immutable name)
     (immutable pointer)
     (mutable source)
     (mutable origin)
     (mutable tint))
    (protocol
     (lambda (new)
       (lambda (name fptr)
	 (assert (ftype-pointer? fptr))
	 (let ([width (ftype-ref Texture2D (width) fptr)]
	       [height (ftype-ref Texture2D (height) fptr)]
	       [origin (make-vector2 0.0 0.0)]
	       [white (make-color 255 255 255 255)])
	   (new
	    name fptr
	    (make-rectangle
	     0.0 0.0
	     (exact->inexact width)
	     (exact->inexact height))
	    origin white))))))

  (define texture-width
    (lambda (tex)
      (exact->inexact
       (ftype-ref Texture2D (width) (texture-pointer tex)))))

  (define texture-height
    (lambda (tex)
      (exact->inexact
       (ftype-ref Texture2D (height) (texture-pointer tex)))))
  )
