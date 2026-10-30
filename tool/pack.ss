(library (tool pack)
  (export pack-file container-format container)
  (import (chezscheme))
  
  (define-enumeration container-format
    (rres zip tar)
    container)

					; res format
  (define RRES_SIGNATURE (bytevector-u32-ref (string->utf8 "rres") 0 (endianness big)))
  (define rres-file-header
    (lambda (ver res-count cd-offset)
      (let ([header (make-bytevector 16)])
	(bytevector-u32-set! header 0 RRES_SIGNATURE (endianness big))
	(bytevector-u16-set! header 4 ver (endianness little))
	(bytevector-u16-set! header 6 res-count (endianness little))
	(bytevector-u32-set! header 8 cd-offset (endianness little))
	header)))

  (define rres-resource-chunk
    (lambda ()))

  (define pack-file
    (lambda (in out c-f)
      (call-with-port (open-file-input-port in
					    (file-options)
					    (buffer-mode block)
					    #f)
	(lambda (i)
	  (let ([bv (get-bytevector-all i)])
	    (if (eof-object? bv) #vu8() bv)
	    )
	  (call-with-port (open-file-output-port out
						 (file-options replace)
						 (buffer-mode block)
						 #f)
	    (lambda (o)
	      (let loop ()
		(let ([chunk (get-bytevector-n i 4096)])
		  (unless (eof-object? chunk)
		    (put-bytevector o chunk)
		    (loop))))))))
      ))
  )
