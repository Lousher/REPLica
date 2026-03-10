(library (vm bundle)
  (export pack mount close ref)
  (import (chezscheme))

  (define xor-transform!
    (lambda (data key)
      (let ([d-len (bytevector-length data)]
	    [k-len (bytevector-length key)])
	(let loop ([i 0])
	  (unless (= i d-len)
	    (let ([data-val (bytevector-u8-ref data i)]
		  [key-val (bytevector-u8-ref key (remainder i k-len))])
	      (bytevector-u8-set! data i (logxor data-val key-val))
	      (loop (+ i 1))))))))

  (define XOR_KEY (string->utf8 "replica_secret01"))
  (define MAGIC (string->utf8 "RPK1"))
  (define ALIGN 16)

  (define file->bv
    (lambda (path)
      (call-with-port
	  (open-file-input-port path)
	get-bytevector-all)))

  (define put-padding
    (lambda (p align)
      (let* ([pos (port-position p)]
	     [pad-len (remainder (- align (remainder pos align)) align)])
	(unless (zero? pad-len)
	  (put-bytevector p (make-bytevector pad-len 0))))))

  (define put-u64-le
    (lambda (p n)
      (let ([bv (make-bytevector 8)])
	(bytevector-u64-set! bv 0 n (endianness little))
	(put-bytevector p bv))))

  (define ref-u64-le
    (lambda (p)
      (let ([bv (get-bytevector-n p 8)])
	(bytevector-u64-ref bv 0 (endianness little)))))

  (define fnv-1a
    (lambda (str)
      (let ([bytes (string->utf8 str)]
	    [prime 16777619]
	    [offset-basis 2166136261])
	(let loop ([i 0] [hash offset-basis])
	  (if (= i (bytevector-length bytes))
	      hash
	      (loop (+ i 1)
		    (logand #xffffffff
			    (ash (* (logxor hash (bytevector-u8-ref bytes i)) prime) 0))))))))

  (define-record-type bundle
    (fields
     (mutable port)
     table path))

  (define pack
    (lambda (output assets)
      (let ([p (open-file-output-port output (file-options replace) (buffer-mode block))])
	; header: magic 4 + offset 8
	(put-bytevector p MAGIC)
	(let ([header-bv (make-bytevector 8 0)])
	  (put-bytevector p header-bv))
	; data blocks
	(let ([index-data (map
			   (lambda (asset)
			     (let* ([id (car asset)]
				    [ext (path-extension (cadr asset))]
				    [data (file->bv (cadr asset))]
				    [__ (xor-transform! data XOR_KEY)]
				    [_ (put-padding p 16)]
				    [offset (port-position p)]
				    [len (bytevector-length data)])
			       (put-bytevector p data)
			       (list (fnv-1a id) offset len ext)))
			   assets)])
	  (let* ([index-pos (port-position p)]
		 [index-str (format "~s" index-data)]
		 [index-bv (string->utf8 index-str)])
	    (xor-transform! index-bv XOR_KEY)
	    (put-bytevector p index-bv)
	    (set-port-position! p 4)
	    (let ([off-bv (make-bytevector 8 0)])
	      (bytevector-u64-set! off-bv 0 index-pos (endianness little))
	      (put-bytevector p off-bv))))
	(close-port p)
	)))

  (define mount
    (lambda (path)
      (let* ([p (open-file-input-port path (file-options) (buffer-mode block))]
	     [magic (get-bytevector-n p 4)])
	(unless (bytevector=? magic MAGIC)
	  (error 'mount "Invalid Magic Number" path))
	(let* ([off-bv (get-bytevector-n p 8)]
	       [index-offset (bytevector-u64-ref off-bv 0 (endianness little))]
	       [_ (set-port-position! p index-offset)]
	       [index-bv (get-bytevector-all p)]
	       [__ (xor-transform! index-bv XOR_KEY)]
	       [index-str (utf8->string index-bv)]
	       [raw-index (read (open-string-input-port index-str))]
	       [table (make-hashtable (lambda (x) x) =)])
	  (for-each
	   (lambda (e) (hashtable-set! table (car e) (cdr e)))
	   raw-index)
	  (make-bundle p table path)))))

  (define ref
    (lambda (b str)
      (let ([info (hashtable-ref (bundle-table b) (fnv-1a str) #f)])
	(if info
	    (begin
	      (set-port-position! (bundle-port b) (car info))
	      (let ([data (get-bytevector-n (bundle-port b) (cadr info))])
		(xor-transform! data XOR_KEY)
		(values (format ".~a" (caddr info)) data (cadr info))
		))
	    (values #f #f #f)))))

  (define close
    (lambda (b)
      (when (bundle-port b)
	(close-port (bundle-port b))
	(bundle-port-set! b #f))))
  )
