(library (core frame)
  (export
   frame? make-frame
   frame-x frame-y frame-width frame-height
   frame-x-set! frame-y-set! frame-width-set! frame-height-set!
   frame-rotation frame-rotation-set!
   texture->frame
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
     (mutable rotation))
    (protocol
     (lambda (new)
       (lambda (x y w h rot)
	 (assert (for-all flonum? (list x y w h rot)))
	 (new x y w h rot)))))

  (define texture->frame
    (lambda (tex x y rot)
      (assert (texture? tex))
      (let ([src (texture-source tex)])
	(make-frame
	 x y
	 (rectangle-width src)
	 (rectangle-height src)
	 rot))))
  
  )
