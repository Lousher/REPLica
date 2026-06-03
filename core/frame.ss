(library (core frame)
  (export
   frame? make-frame
   frame-x frame-y frame-width frame-height
   frame-x-set! frame-y-set! frame-width-set! frame-height-set!
   frame-rotation frame-rotation-set!
   frame-pivot frame-pivot-set!
   )
  (import
   (chezscheme)
   (core type))

  (define-record-type frame
    (fields
     (mutable x)
     (mutable y)
     (mutable width)
     (mutable height)
     (mutable pivot)
     (mutable rotation))
    (protocol
     (lambda (new)
       (lambda (x y w h piv rot)
	 (assert (for-all flonum? (list x y w h rot)))
	 (assert (vector2? piv))
	 (new x y w h piv rot)))))
  )
