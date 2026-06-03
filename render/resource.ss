(library (render resource)
  (export
   make-asset asset? asset-pointer
   assets-collect)
  (import
   (chezscheme)
   (ffi raylib binding))

  (define assets-guardian (make-guardian))

  (define assets-collect
    (lambda ()
      (let loop ([obj (assets-guardian)])
	(when obj
	  (display "Place holder for cleaning foreign resource\n")
	  (loop (assets-guardian))))))

  (define-record-type asset
    (fields (immutable pointer))
    (protocol
     (lambda (new)
       (lambda (fptr)
	 (assert (ftype-pointer? fptr))
	 (let ([ass (new fptr)])
	   (assets-guardian ass)
	   ass)
	 ))))

  )
