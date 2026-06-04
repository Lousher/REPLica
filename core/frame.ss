(library (core frame)
  (export
   frame? make-frame
   frame-width frame-height frame-anchor frame-origin frame-rotation
   frame-width-set! frame-height-set!
   frame-rotation-set!
   frame-origin-set!
   frame-anchor-set!
   )
  (import
   (chezscheme)
   (core type))

  (define-record-type frame
    (fields
     (mutable width)
     (mutable height)
     (mutable anchor)
     (mutable origin)
     (mutable rotation))
    (protocol
     (lambda (new)
       (lambda (w h anchor ori rot)
	 (assert (for-all flonum? (list w h rot)))
	 (assert (for-all vector2? (list anchor ori)))
	 (new w h anchor ori rot)))))
  )
