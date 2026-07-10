(library (core meta)
  (export
   image-size audio-duration
   png-size jpg-size gif-size bmp-size webp-size
   wav-duration flac-duration ogg-duration mp3-duration)
  (import
   (chezscheme))

  ;; ============ 图片 ============

  (define png-size
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 8)                       ; PNG 签名
	  (let ([chunk-head (get-bytevector-n ip 16)])   ; length+"IHDR"+width+height
	    (values (bytevector-u32-ref chunk-head 8 (endianness big))
		    (bytevector-u32-ref chunk-head 12 (endianness big))))))))

  (define jpg-size
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-u8 ip) (get-u8 ip)                       ; SOI 0xFFD8
	  (let loop ()
	    (let* ([marker (let skip-ff ([b (get-u8 ip)])
			     (if (= b #xFF) (skip-ff (get-u8 ip)) b))]
		   [sof? (or (<= #xC0 marker #xC3)
			     (<= #xC5 marker #xC7)
			     (<= #xC9 marker #xCB)
			     (<= #xCD marker #xCF))])
	      (if sof?
		  (let* ([_len (get-bytevector-n ip 2)]
			 [_precision (get-u8 ip)]
			 [h (bytevector-u16-ref (get-bytevector-n ip 2) 0 (endianness big))]
			 [w (bytevector-u16-ref (get-bytevector-n ip 2) 0 (endianness big))])
		    (values w h))
		  (let ([seg-len (bytevector-u16-ref (get-bytevector-n ip 2) 0 (endianness big))])
		    (get-bytevector-n ip (- seg-len 2))
		    (loop)))))))))

  (define gif-size
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 6)                       ; "GIF87a"/"GIF89a"
	  (let ([wh (get-bytevector-n ip 4)])
	    (values (bytevector-u16-ref wh 0 (endianness little))
		    (bytevector-u16-ref wh 2 (endianness little))))))))

  (define bmp-size
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 14)                      ; BITMAPFILEHEADER
	  (get-bytevector-n ip 4)                       ; DIB 头自身长度字段，忽略
	  (let ([wh (get-bytevector-n ip 8)])
	    (values (bytevector-s32-ref wh 0 (endianness little))
		    (abs (bytevector-s32-ref wh 4 (endianness little)))))))))  ; 高度可能是负数(自底向上)

  (define bv-u24-le
    (lambda (bv offset)
      (+ (bytevector-u8-ref bv offset)
	 (* 256 (bytevector-u8-ref bv (+ offset 1)))
	 (* 65536 (bytevector-u8-ref bv (+ offset 2))))))

  (define webp-size
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 12)                      ; "RIFF"+size+"WEBP"
	  (let* ([fourcc (utf8->string (get-bytevector-n ip 4))]
		 [_chunk-size (get-bytevector-n ip 4)])
	    (cond
	     [(string=? fourcc "VP8X")
	      (let ([data (get-bytevector-n ip 10)])
		(values (+ 1 (bv-u24-le data 4))
			(+ 1 (bv-u24-le data 7))))]
	     [(string=? fourcc "VP8L")
	      (let* ([data (get-bytevector-n ip 5)]
		     [packed (bytevector-u32-ref data 1 (endianness little))])
		(values (+ 1 (bitwise-and packed #x3FFF))
			(+ 1 (bitwise-and (bitwise-arithmetic-shift-right packed 14) #x3FFF))))]
	     [(string=? fourcc "VP8 ")
	      (get-bytevector-n ip 3)                    ; frame tag
	      (get-bytevector-n ip 3)                    ; start code 0x9d 0x01 0x2a
	      (let ([wh (get-bytevector-n ip 4)])
		(values (bitwise-and (bytevector-u16-ref wh 0 (endianness little)) #x3FFF)
			(bitwise-and (bytevector-u16-ref wh 2 (endianness little)) #x3FFF)))]
	     [else (values #f #f)]))))))

  ;; ============ 音频 ============

  (define wav-duration
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 12)                      ; "RIFF"+size+"WAVE"
	  (let loop ([byte-rate #f] [data-size #f])
	    (if (and byte-rate data-size)
		(/ data-size byte-rate)
		(let ([id (get-bytevector-n ip 4)])
		  (if (eof-object? id)
		      #f
		      (let* ([sz (bytevector-u32-ref (get-bytevector-n ip 4) 0 (endianness little))]
			     [id-str (utf8->string id)])
			(cond
			 [(string=? id-str "fmt ")
			  (let ([fmt (get-bytevector-n ip sz)])
			    (when (odd? sz) (get-u8 ip))
			    (loop (bytevector-u32-ref fmt 8 (endianness little)) data-size))]
			 [(string=? id-str "data")
			  (loop byte-rate sz)]           ; 不消费 data，避免大文件整段读入
			 [else
			  (get-bytevector-n ip sz)
			  (when (odd? sz) (get-u8 ip))
			  (loop byte-rate data-size)]))))))))))

  (define flac-duration
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 4)                       ; "fLaC"
	  (get-bytevector-n ip 4)                       ; metadata block header(必为 STREAMINFO)
	  (let* ([streaminfo (get-bytevector-n ip 34)]
		 [packed (bytevector-uint-ref streaminfo 10 (endianness big) 8)]
		 [sample-rate (bitwise-arithmetic-shift-right packed 44)]
		 [total-samples (bitwise-and packed #xFFFFFFFFF)])  ; 低 36 位
	    (/ total-samples sample-rate))))))

  (define ogg-first-page-sample-rate
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (get-bytevector-n ip 4)                       ; "OggS"
	  (get-bytevector-n ip 22)                      ; version..checksum
	  (let* ([nseg (bytevector-u8-ref (get-bytevector-n ip 1) 0)]
		 [seg-table (get-bytevector-n ip nseg)]
		 [page-size (do ([i 0 (+ i 1)] [s 0 (+ s (bytevector-u8-ref seg-table i))])
				((= i nseg) s))]
		 [data (get-bytevector-n ip page-size)]
		 [id-str (make-bytevector 6 0)])
	    (bytevector-copy! data 1 id-str 0 6)
	    (if (and (>= (bytevector-length data) 16)
		     (= (bytevector-u8-ref data 0) 1)
		     (string=? (utf8->string id-str) "vorbis"))
		(bytevector-u32-ref data 12 (endianness little))
		#f))))))

  (define ogg-last-granule-position
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (let* ([len (port-length ip)]
		 [tail-size (min len 65536)])
	    (set-port-position! ip (- len tail-size))
	    (let ([tail (get-bytevector-n ip tail-size)])
	      (let loop ([i (- tail-size 27)])
		(cond
		 [(< i 0) #f]
		 [(and (= (bytevector-u8-ref tail i) #x4F)      ; O
		       (= (bytevector-u8-ref tail (+ i 1)) #x67) ; g
		       (= (bytevector-u8-ref tail (+ i 2)) #x67) ; g
		       (= (bytevector-u8-ref tail (+ i 3)) #x53));S
		  (bytevector-uint-ref tail (+ i 6) (endianness little) 8)]
		 [else (loop (- i 1))]))))))))

  (define ogg-duration
    (lambda (p)
      (let ([sample-rate (ogg-first-page-sample-rate p)]
	    [total-samples (ogg-last-granule-position p)])
	(and sample-rate total-samples
	     (/ total-samples sample-rate)))))

  (define mp3-bitrate-table  '#(0 32 40 48 56 64 80 96 112 128 160 192 224 256 320))  ; MPEG1 LayerIII, kbps
  (define mp3-samplerate-table '#(44100 48000 32000))

  (define skip-id3v2!
    (lambda (ip)
      (let ([hdr (get-bytevector-n ip 10)])
	(if (and (= (bytevector-u8-ref hdr 0) #x49)
		 (= (bytevector-u8-ref hdr 1) #x44)
		 (= (bytevector-u8-ref hdr 2) #x33))
	    (let ([size (+ (* (bytevector-u8-ref hdr 6) (expt 2 21))
			   (* (bytevector-u8-ref hdr 7) (expt 2 14))
			   (* (bytevector-u8-ref hdr 8) (expt 2 7))
			   (bytevector-u8-ref hdr 9))])
	      (get-bytevector-n ip size))
	    (set-port-position! ip 0)))))

  (define mp3-duration
    (lambda (p)
      (call-with-port (open-file-input-port p)
	(lambda (ip)
	  (skip-id3v2! ip)
	  (let loop ([b (get-u8 ip)])
	    (cond
	     [(eof-object? b) #f]
	     [(not (= b #xFF)) (loop (get-u8 ip))]
	     [else
	      (let ([b2 (get-u8 ip)])
		(if (or (eof-object? b2) (not (= (bitwise-and b2 #xE0) #xE0)))
		    (loop (if (eof-object? b2) b2 b2))
		    (let* ([b3b4 (get-bytevector-n ip 2)]
			   [b3 (bytevector-u8-ref b3b4 0)]
			   [bitrate-idx (bitwise-and (bitwise-arithmetic-shift-right b3 4) #xF)]
			   [samplerate-idx (bitwise-and (bitwise-arithmetic-shift-right b3 2) #x3)]
			   [bitrate (* 1000 (vector-ref mp3-bitrate-table bitrate-idx))]
			   [samplerate (vector-ref mp3-samplerate-table samplerate-idx)])
		      (get-bytevector-n ip 32)          ; 跳过 side info(按 MPEG1 立体声估算)
		      (let ([tag (get-bytevector-n ip 4)])
			(if (and (= (bytevector-length tag) 4)
				 (or (string=? (utf8->string tag) "Xing")
				     (string=? (utf8->string tag) "Info")))
			    (let* ([flags (bytevector-u32-ref (get-bytevector-n ip 4) 0 (endianness big))]
				   [frame-count (if (bitwise-bit-set? flags 0)
						    (bytevector-u32-ref (get-bytevector-n ip 4) 0 (endianness big))
						    #f)])
			      (and frame-count (/ (* frame-count 1152) samplerate)))
			    (let ([remaining (- (port-length ip) (port-position ip))])
			      (/ (* 8.0 remaining) bitrate)))))))]))))))

  ;; ============ 统一入口 ============

  (define ext
    (lambda (path)
      (let ([e (path-extension path)])
	(and (> (string-length e) 0) (string->symbol (string-downcase e))))))

  (define image-size
    (lambda (path)
      (case (ext path)
	[(png) (png-size path)]
	[(jpg jpeg) (jpg-size path)]
	[(gif) (gif-size path)]
	[(bmp) (bmp-size path)]
	[(webp) (webp-size path)]
	[else (values #f #f)])))

  (define audio-duration
    (lambda (path)
      (case (ext path)
	[(wav) (wav-duration path)]
	[(flac) (flac-duration path)]
	[(ogg oga) (ogg-duration path)]
	[(mp3) (mp3-duration path)]
	[else #f])))
  )
