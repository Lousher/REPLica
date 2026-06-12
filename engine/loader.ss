(library (engine loader)
  (export load! load-texture)
  (import
   (chezscheme)
   (core type)
   (ffi raylib binding))

  (define-record-type asset
    (fields
     (immutable path)
     (immutable type)
     (mutable status)
     (mutable data)
     (immutable on-load)
     ))

  (define QUEUE '())
  
  (define load!
    (lambda ()
      (let loop ()
	(unless (null? QUEUE)
	  (let ([a (car QUEUE)])
	    (set! QUEUE (cdr QUEUE))
	    (case (asset-type a)
	      [(texture)
	       (let ([tex (LoadTexture (asset-path a))])
		 (asset-data-set! a tex)
		 (asset-status-set! a 'loaded)
		 ((asset-on-load a) a))])
	    )
	  (loop)))
      ))

  (define load-texture
    (lambda (path)
      (let* ([tex (make-texture path)]
	     [setter
	      (lambda (a)
		(let* ([fptr (asset-data a)]
		       [width (ftype-ref Texture2D (width) fptr)]
		       [height (ftype-ref Texture2D (height) fptr)])
		  (SetTextureFilter fptr TEXTURE_FILTER_BILINEAR)
		  (texture-pointer-set! tex fptr)
		  (texture-source-set! tex (make-rectangle
					    0.0 0.0
					    (exact->inexact width)
					    (exact->inexact height)))))]
	     [a (make-asset path 'texture 'pending #f
			    setter)])
	(set! QUEUE (append QUEUE (list a)))
	tex)))
  )
