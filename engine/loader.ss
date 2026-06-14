(library (engine loader)
  (export load! load-texture CACHE)
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
     (mutable on-load)
     ))

  (define QUEUE '())
  (define CACHE (make-hashtable string-hash string=?))
  
  (define load!
    (lambda ()
      (unless (null? QUEUE)
	(TraceLog LOG_INFO (format "Queue ara ~a" QUEUE))
	(let ([a (car QUEUE)])
	  (case (asset-type a)
	    [(texture)
	     (let ([tex (LoadTexture (asset-path a))])
	       (asset-data-set! a tex)
	       (asset-status-set! a 'loaded)
	       ((asset-on-load a) a)
	       )])
	  (set! QUEUE (cdr QUEUE)))
	)
      ))

  (define load-texture
    (lambda (path)
      (if (hashtable-contains? CACHE path)
	  (hashtable-ref CACHE path #f)
	  (let* ([tex (make-texture path)]
		 [on-load (lambda (a)
			    (let* ([fptr (asset-data a)]
				   [w (ftype-ref Texture2D (width) fptr)]
				   [h (ftype-ref Texture2D (height) fptr)])
			      (SetTextureFilter fptr TEXTURE_FILTER_BILINEAR)
			      (texture-pointer-set! tex fptr)
			      (texture-source-set! tex (make-rectangle 0.0 0.0 (inexact w) (inexact h)))))]
		 [a (make-asset path 'texture 'pending #f on-load)])
	    (hashtable-set! CACHE path tex)
	    (set! QUEUE (append QUEUE (list a)))
	    tex))))
  )
