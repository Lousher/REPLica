(library (engine loader)
  (export CACHE color->texture
	  linear-color->texture
	  make-perlin-noise-texture
	  file->glyphs glyphs->charmap
	  load! load-texture
	  load-sound)
  (import
   (chezscheme)
   (core type)
   (ffi raylib binding))

  (define CACHE (make-hashtable string-hash string=?))
  (define-record-type asset
    (sealed #t)
    (fields
     (immutable path)
     (immutable type)
     (mutable status)
     (mutable data)
     (mutable on-load)))

  (define color->hex-string
    (lambda (c)
      (format "#~2,'0x~2,'0x~2,'0x~2,'0x"
	      (color-r c)
	      (color-g c)
	      (color-b c)
	      (color-a c))))
  
  (define color->texture
    (lambda (c w h)
      (let* ([hex-str (color->hex-string c)]
	     [id-str (format "~a ~a*~a" hex-str w h)])
	(if (hashtable-contains? CACHE id-str)
	    (hashtable-ref CACHE id-str #f)
	    (let* ([c-img (GenImageColor w h (color->Color c))]
		   [c-tex (LoadTextureFromImage c-img)])
	      (UnloadImage c-img)
	      (let ([tex (make-texture id-str c-tex)])
		(hashtable-set! CACHE id-str tex)
		tex))))))

  (define linear-color->texture
    (case-lambda
      [(c-start c-end w h rot)
       (let* ([c-img (GenImageGradientLinear w h rot (color->Color c-start)
					     (color->Color c-end))]
	      [c-tex (LoadTextureFromImage c-img)])
	 (UnloadImage c-img)
	 (make-texture (color->hex-string c-start) c-tex))]
      [(c-s c-e w h)
       (linear-color->texture c-s c-e w h 0)]))

  (define make-perlin-noise-texture
    (lambda (w h ox oy s)
      (assert (for-all integer? (list w h ox oy)))
      (assert (flonum? s))
      (let ([n-img (GenImagePerlinNoise w h ox oy s)])
	(ImageFormat n-img PIXELFORMAT_UNCOMPRESSED_GRAYSCALE)
	(let ([n-tex (LoadTextureFromImage n-img)])
	  (UnloadImage n-img)
	  (SetTextureWrap n-tex TEXTURE_WRAP_REPEAT)
	  (make-texture "perlin" n-tex))
	)))

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



  (define QUEUE '())
  
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
	       )]
	    [(sound)
	     (let ([snd (LoadSound (asset-path a))])
	       (asset-data-set! a snd)
	       (asset-status-set! a 'loaded)
	       ((asset-on-load a) a)
	       )])
	  (set! QUEUE (cdr QUEUE))))))

  (define load-texture
    (lambda (path)
      (if (hashtable-contains? CACHE path)
	  (hashtable-ref CACHE path #f)
	  (let* ([tex (make-texture path)]
		 [on-load (lambda (a)
			    (let* ([fptr (asset-data a)]
				   [w (ftype-ref Texture2D (width) fptr)]
				   [h (ftype-ref Texture2D (height) fptr)])
			      (GenTextureMipmaps fptr)
			      (SetTextureFilter fptr TEXTURE_FILTER_TRILINEAR)
			      (texture-pointer-set! tex fptr)
			      (texture-source-set! tex (make-rectangle 0.0 0.0 (inexact w) (inexact h)))))]
		 [a (make-asset path 'texture 'pending #f on-load)])
	    (hashtable-set! CACHE path tex)
	    (set! QUEUE (append QUEUE (list a)))
	    tex))))

  (define load-sound
    (lambda (path)
      (if (hashtable-contains? CACHE path)
	  (hashtable-ref CACHE path #f)
	  (let* ([snd (make-sound path)]
		 [on-load (lambda (a)
			    (let* ([fptr (asset-data a)])
			      (sound-pointer-set! snd fptr)
			      ))]
		 [a (make-asset path 'sound 'pending #f on-load)])
	    (hashtable-set! CACHE path snd)
	    (set! QUEUE (append QUEUE (list a)))
	    snd))))
  )
