(library (engine resource)
  (export
   make-manager
   mount unmount
   make-texture-node
   loader-update!
   )
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (prefix (tool bundle) b:))

  (define-record-type manager
    (fields (mutable bundles)
	    (mutable cache)
	    (mutable pending)
	    (mutable data)
	    (mutable lock)
	    )
    (protocol
     (lambda (new)
       (lambda ()
	 (new '()
	      (make-hashtable string-hash string=?)
	      (make-eq-hashtable)
	      (make-hashtable string-hash string=?)
	      (make-mutex))))))

  (define ref
    (lambda (rm path)
      (let loop ([bundles (manager-bundles rm)])
	(if (null? bundles)
	    (values #f #f #f)
	    (let-values ([(ext data len) (b:ref (car bundles) path)])
	      (if data
		  (values ext data len)
		  (loop (cdr bundles))))))))

  (define mount
    (lambda (rm path)
      (let ([b (b:mount path)])
	(manager-bundles-set! rm
			      (cons b (manager-bundles rm))))))

  (define unmount
    (lambda (rm b)
      (b:unmount b)
      (manager-bundles-set! rm
			    (filter (lambda (x)
				      (not (eq? x b)))
				    (manager-bundles rm)))))

  (define make-texture-node
    (lambda (rm id path)
      (TraceLog LOG_INFO (format "RESOURCE: Creating texture node: id=~a path=~a" id path))
      (let ([node (make-node id 'texture #f #f)]
	    [cache (manager-cache rm)])
	(let ([tex (hashtable-ref cache path #f)])
	  (if tex
	      (begin
		(TraceLog LOG_INFO (format "RESOURCE: Texture already caches: ~a" path))
		(node-resource-set! node tex))
	      (begin
		(TraceLog LOG_INFO (format "RESOURCE: Cache miss, starting async load: ~a" path))
		(with-mutex (manager-lock rm)
		  (hashtable-set! (manager-pending rm) node path))
		(fork-thread
		 (lambda ()
		   (TraceLog LOG_INFO (format "RESOURCE: Background thread started for: ~a" path))
		   (let-values ([(ext data len) (ref rm path)])
		     (if data
			 (let ([img (LoadImageFromMemory ext data len)])
			   (TraceLog LOG_INFO (format "RESOURCE: Decoded image: ~a (size=~a bytes)" path len))
			   (with-mutex (manager-lock rm)
			     (hashtable-set! (manager-data rm) path img)))
			 (TraceLog LOG_ERROR (format "RESOURCE: Async load failed: ~a" path)))))))))
	node)))

  (define loader-update!
    (lambda (rm)
      (let ([pending (manager-pending rm)]
	    [data (manager-data rm)]
	    [cache (manager-cache rm)]
	    [lock (manager-lock rm)])
	(with-mutex lock
	  (let ([path->nodes (make-hashtable string-hash string=?)])
	    (let ([nodes (hashtable-keys pending)])
	      (vector-for-each
	       (lambda (node)
		 (let ([path (hashtable-ref pending node #f)])
		   (when path
		     (let ([node-list (hashtable-ref path->nodes path '())])
		       (hashtable-set! path->nodes path (cons node node-list))))))
	       nodes))
	    (let ([paths (hashtable-keys data)])
	      (vector-for-each
	       (lambda (path)
		 (let ([waiting-nodes (hashtable-ref path->nodes path '())])
		   (unless (null? waiting-nodes)
		     (let ([img (hashtable-ref data path #f)])
		       (when img
			 (let ([tex (LoadTextureFromImage img)])
			   (TraceLog LOG_INFO (format "RESOURCE: Uploading texture for ~a, nodes count: ~a" path (length waiting-nodes)))
			   (UnloadImage img)
			   (if (zero? (Texture-id tex))
			       (begin
				 (TraceLog LOG_ERROR (format "RESOURCE: Failed to create texture from memory: ~a" path))
				 (for-each
				  (lambda (node)
				    (hashtable-delete! pending node))
				  waiting-nodes))
			       (begin
				 (TraceLog LOG_INFO (format "RESOURCE: Texture uploaded: ~a (id=~a)" path (Texture-id tex)))
				 (hashtable-set! cache path tex)
				 (for-each
				  (lambda (node)
				    (node-resource-set! node tex)
				    (node-type-set! node 'texture)
				    (hashtable-delete! pending node))
				  waiting-nodes)
				 (hashtable-delete! data path)))
			   ))))))
	       paths)))))))
  )
