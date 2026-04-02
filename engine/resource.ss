(library (engine resource)
  (export cache ref)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant))

  (define *resources*
    (make-hashtable string-hash string=?))

  (define cache
    (lambda (path)
      (unless (hashtable-contains? *resources* path)
	(case (string->symbol (path-extension path))
	  [(png)
	   (let ([tex (LoadTexture path)])
	     (hashtable-set! *resources* path tex))]))
      ))

  (define ref
    (lambda (path)
      (hashtable-ref *resources* path #f)))
  )
