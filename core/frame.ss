(library (core frame)
  (export
   frame? make-frame
   frame-x frame-y frame-width frame-height
   frame-x-set! frame-y-set! frame-width-set! frame-height-set!
   )
  (import
   (chezscheme))

  (define-record-type frame
    (fields
     (mutable x)
     (mutable y)
     (mutable width)
     (mutable height))
    (protocol
     (lambda (new)
       (lambda (x y w h)
	 (assert (for-all flonum? (list x y w h)))
	 (new x y w h)))))
  )
