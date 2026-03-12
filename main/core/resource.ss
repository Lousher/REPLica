(library (core resource)
  (export warmup! ref unload!)
  (import (chezscheme)
	  (prefix (vm bundle) bundle:))

  (define *resources* (make-hashtable (lambda (x) x) =))

  (define load!
    (lambda (b id)
      (let-values ([(ext data len) (bundle:ref b id)])
	(if data
	    (let* ([img (LoadImageFromMemory ext data len)]
		   [tex (LoadTextureFromImage img)])
	      (UnloadImage img)
	      (hashtable-set! *resources* (bundle:fnv-1a id) tex)
	      tex)
	    #f))))
  
  (define warmup!
    (lambda (b ids)
      (for-each (lambda (id)
		  (unless (hashtable-contains? *resources* (bundle:fnv-1a id))
		    (load! b id)))
		ids)))

  (define ref
    (lambda (id)
      (hashtable-ref *resources* (bundle:fnv-1a id) #f)))

  (define unload!
    (lambda (id)
      (let ([ptr (ref id)])
	(when ptr
	  (UnloadTexture ptr)
	  (hashtable-delete! *resources* (bundle:fnv-1a id))))))
  )
