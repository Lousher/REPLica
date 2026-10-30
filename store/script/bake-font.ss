(load-shared-object "ffi/raylib/libraylib.so.6.0.0")
(import (ffi raylib binding))
(import (core type))

(define glyphinfos+recs->glyph
  (lambda (glyphs-fptr recs-ptr count)
    (let loop ([i 0] [res '()])
      (if (= i count)
	  (reverse res)
	  (let* ([cp (ftype-ref GlyphInfo (value) glyphs-fptr i)]
		 [ox (ftype-ref GlyphInfo (offsetX) glyphs-fptr i)]
		 [oy (ftype-ref GlyphInfo (offsetY) glyphs-fptr i)]
		 [adv (ftype-ref GlyphInfo (advanceX) glyphs-fptr i)]
		 [ax (ftype-ref Rectangle (x) recs-ptr i)]
		 [ay (ftype-ref Rectangle (y) recs-ptr i)]
		 [aw (ftype-ref Rectangle (width) recs-ptr i)]
		 [ah (ftype-ref Rectangle (height) recs-ptr i)]
		 )
	    (loop (+ i 1)
		  (cons (make-glyph cp
				    (make-rectangle
				     (inexact ax)
				     (inexact ay)
				     (inexact aw)
				     (inexact ah))
				    (make-vector2
				     (inexact ox)
				     (inexact oy))
				    adv)
			res))
	    )))
    ))

(define (codepoints->bytevector cps)
  (let* ((n (length cps))
         (bv (make-bytevector (* n 4))))
    (do ((i 0 (+ i 1))
         (lst cps (cdr lst)))
        ((null? lst) bv)
      (bytevector-u32-native-set! bv (* i 4) (car lst)))))

(define bake-sdf
  (lambda (ttf-path output-png output-bin cps size padding)
    (let ([cp-count (length cps)]
	  [cp-bv (codepoints->bytevector cps)])
      (let* ([font-bv (call-with-port (open-file-input-port ttf-path)
			get-bytevector-all)]
	     [font-data-size (bytevector-length font-bv)]
	     [glyph-count-fptr (make-ftype-pointer integer-32 (foreign-alloc (ftype-sizeof integer-32)))]
	     [glyphs-fptr (LoadFontData font-bv font-data-size size cp-bv cp-count FONT_SDF glyph-count-fptr)])
	(if (not glyphs-fptr)
	    (error 'bake-sdf "Cannot Load Font Data")
	    (begin
	      (display "Begin to generate atlas image\n")
	      (let* ([recs-box (make-ftype-pointer *Rectangle (foreign-alloc (ftype-sizeof *Rectangle)))]
		     [atlas-img (GenImageFontAtlas glyphs-fptr recs-box cp-count size padding 0)]
		     [recs-ptr (ftype-ref *Rectangle () recs-box)])
		(ExportImage atlas-img output-png)
		(display (format "Image has been saved in: ~a\n" output-png))
		(display "Begin writting binary data\n")
		(call-with-port (open-file-output-port output-bin (file-options no-fail) (buffer-mode block) #f)
		  (lambda (p)
		    (let ([glyphs (glyphinfos+recs->glyph glyphs-fptr recs-ptr cp-count)])
		      (fasl-write glyphs p))))
		)))))))

(define iota*
  (case-lambda
    [(count) 
     (iota count)]  ;; 只有一个参数时，回退给 Chez 的高原生版本
    [(count start)
     (let loop ([i count] [acc '()])
       (if (zero? i)
           acc
           (let ([i-1 (- i 1)])
             (loop i-1 (cons (+ start i-1) acc)))))]
    [(count start step)
     (let loop ([i count] [acc '()])
       (if (zero? i)
           acc
           (let ([i-1 (- i 1)])
             (loop i-1 (cons (+ start (* i-1 step)) acc)))))]))

(define (cjk-basic-codepoints)
  (iota* 64 #x3000))

;; 生成 ASCII 可打印字符码点列表
(define (ascii-codepoints)
  (iota* 95 32))

;; 生成 CJK 标点符号码点列表 (U+3000 ~ U+303F)
(define (cjk-punctuation-codepoints)
  (iota* 20092 #x4E00))

(define (general-punctuation-codepoints)
  (iota* 112 #x2000))

(define (latin-supplement-codepoints)
  (iota* 128 #x0080))

;; 生成全角标点码点列表 (U+FF00 ~ U+FFEF)
(define (fullwidth-punctuation-codepoints)
  (iota* 240 #xFF00))


;; 生成完整中文支持的码点列表
(define (chinese-full-codepoints)
  (append (ascii-codepoints)
          (cjk-punctuation-codepoints)
          (fullwidth-punctuation-codepoints)
          (cjk-basic-codepoints)
	  (general-punctuation-codepoints)
	  (latin-supplement-codepoints)))

|(call-with-output-file "assets/allchars.txt"
  (lambda (p)
    (write 
     (list->string (map integer->char (chinese-full-codepoints)))
     p
     )))|


(bake-sdf "assets/xiaolai.ttf" "assets/xiaolai.atlas.png" "assets/xiaolai.bin" (ascii-codepoints) 96 12)

