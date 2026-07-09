(library (core type)
  (export
   make-color color->Color Color->color color?
   color->texture linear-color->texture
   color-r color-g color-b color-a
   make-vector2 vector2->Vector2 Vector2->vector2 vector2?
   vector2-x vector2-y
   make-rectangle rectangle->Rectangle Rectangle->rectangle rectangle?
   rectangle-x rectangle-y rectangle-width rectangle-height
   make-texture texture? make-perlin-noise-texture
   make-sound sound?
   sound-path sound-pointer sound-pointer-set!
   texture-path texture-pointer texture-source texture-source-set!
   texture-origin texture-origin-set!
   texture-width texture-height
   texture-pointer-set!
					;make-glyph
   glyph?
   glyph-codepoint glyph-advance glyph-plane glyph-coord
					;make-metrics
   plane?
   plane-left plane-bottom plane-right plane-top
   font-meta? font-meta-atlas font-meta-metrics
   atlas? atlas-type atlas-distance-range atlas-distance-range-middle atlas-size atlas-width atlas-height atlas-y-origin
   metrics?
   metrics-em-size metrics-line-height metrics-ascender metrics-descender metrics-underline-y metrics-underline-thickness
   make-font font?
   font-metadata font-sprite font-charmap
   
   )
  (import
   (chezscheme)
   (ffi raylib binding)
   )

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ ftype)
       (make-ftype-pointer ftype (foreign-alloc (ftype-sizeof ftype)))]))  
  
  (define-record-type rectangle
    (nongenerative rectangle)
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
     (immutable path)
     (mutable pointer)
     (mutable source)
     (mutable origin)
     )
    (protocol
     (lambda (new)
       (case-lambda
	 [(path)
	  (assert (file-exists? path))
	  (new path #f
	       #f
	       (make-vector2 0.0 0.0)
	       )]
	 [(name fptr)
	  (assert (ftype-pointer? fptr))
	  (SetTextureFilter fptr TEXTURE_FILTER_BILINEAR)
	  (let ([width (ftype-ref Texture2D (width) fptr)]
		[height (ftype-ref Texture2D (height) fptr)]
		[origin (make-vector2 0.0 0.0)]
		)
	    (new
	     name fptr
	     (make-rectangle
	      0.0 0.0
	      (exact->inexact width)
	      (exact->inexact height))
	     origin))]))))

  (define-record-type sound
    (fields
     (immutable path)
     (mutable pointer)
     )
    (protocol
     (lambda (new)
       (case-lambda
	 [(path)
	  (assert (file-exists? path))
	  (new path #f)]
	 [(name fptr)
	  (assert (ftype-pointer? fptr))
	  (new name fptr)]))))

  (define color->hex-string
    (lambda (c)
      (format "#~2,'0x~2,'0x~2,'0x~2,'0x"
	      (color-r c)
	      (color-g c)
	      (color-b c)
	      (color-a c))))

  (define color->texture
    (lambda (c w h)
      (let* ([c-img (GenImageColor w h (color->Color c))]
	     [c-tex (LoadTextureFromImage c-img)])
	(UnloadImage c-img)
	(make-texture (color->hex-string c) c-tex))))

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

  (define png-size
    (lambda (p)
      (let ([ip (open-file-input-port p)])
	(call-with-port ip
	  (lambda (p)
	    (let ([sig (get-bytevector-n p 8)]
		  [chunk-head (get-bytevector-n p 16)]
		  )
	      (let ([w (bytevector-u32-ref chunk-head 8 (endianness big))]
		    [h (bytevector-u32-ref chunk-head 12 (endianness big))])
		(values w h))
	      ))))))

  (define jpg-size
    (lambda (p)
      (let ([ip (open-file-input-port p)])
	(call-with-port ip
          (lambda (p)
            ;; 1. 验证 SOI 标记 (0xFF 0xD8)
            (get-u8 p)
	    (get-u8 p)
            ;; 2. 循环查找帧开始标记 (SOF)
            (let loop ()
              ;; 跳过填充字节 0xFF
              (let* ([marker (let skip-ff ([b (get-u8 p)])
                               (if (= b #xFF)
                                   (skip-ff (get-u8 p))
                                   b))]
                     ;; 检查是否为 SOF 标记 (0xC0~0xC3, 0xC5~0xC7, 0xC9~0xCB, 0xCD~0xCF)
                     [sof? (or (<= #xC0 marker #xC3)
                               (<= #xC5 marker #xC7)
                               (<= #xC9 marker #xCB)
                               (<= #xCD marker #xCF))])
		(if sof?
                    ;; 找到 SOF：读取段长度、精度、高度、宽度
                    (let* ([len (bytevector-u16-ref (get-bytevector-n p 2) 0 (endianness big))]
                           [_    (get-u8 p)]                              ; 精度（跳过）
                           [h    (bytevector-u16-ref (get-bytevector-n p 2) 0 (endianness big))]
                           [w    (bytevector-u16-ref (get-bytevector-n p 2) 0 (endianness big))])
                      (values w h))
                    ;; 非 SOF 标记：读取段长度并跳过该段
                    (let ([seg-len (bytevector-u16-ref (get-bytevector-n p 2) 0 (endianness big))])
                      (get-bytevector-n p (- seg-len 2))
                      (loop))))))))))
  
  (define texture-width
    (lambda (tex)
      (let ([p (texture-path tex)]
	    [fptr (texture-pointer tex)])
	(if fptr (inexact (ftype-ref Texture2D (width) fptr))
	    (let ([cal-method (case (path-extension p)
				[("png") png-size]
				[("jpg" "jpeg") jpg-size])])
	      (call-with-values
		  (lambda () (cal-method p))
		(lambda (w h)
		  (inexact w))))
	    ))
      ))

  (define texture-height
    (lambda (tex)
      (let ([p (texture-path tex)]
	    [fptr (texture-pointer tex)])
	(if fptr (inexact (ftype-ref Texture2D (height) fptr))
	    (let ([cal-method (case (path-extension p)
				[("png") png-size]
				[("jpg" "jpeg") jpg-size])])
	      (call-with-values
		  (lambda () (cal-method p))
		(lambda (w h)
		  (inexact h))))
	    ))
      ))

  (define-record-type plane
    (nongenerative plane)
    (fields left bottom right top))

  (define-record-type glyph
    (nongenerative glyph)
    (fields
     (immutable codepoint)
     (immutable advance)
     (immutable plane)			;plane
     (immutable coord)			;rectangle
     )
    )

  (define-record-type font
    (fields metadata sprite charmap))
  
  (define-record-type font-meta
    (nongenerative font-meta)
    (fields atlas metrics))

  (define-record-type atlas
    (nongenerative atlas)
    (fields type distance-range distance-range-middle size width height y-origin))

  (define-record-type metrics
    (nongenerative metrics)
    (fields em-size line-height ascender descender underline-y underline-thickness))
  )
