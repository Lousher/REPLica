(library (engine resource)
  (export
   make-manager
   mount unmount
   make-texture-node
   make-char-node
   make-text-node
   loader-update!
   )
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (prefix (tool bundle) b:))

  (define-record-type manager
    (fields (mutable bundles)
	    (mutable cache) ; string
	    (mutable pending) ;eq
	    (mutable data) ;string
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

  (define load-async
    (lambda (rm node path fn)
      (let ([cache (manager-cache rm)]
	    [data (manager-data rm)]
	    [lock (manager-lock rm)])
	(with-mutex lock
	  (let ([cached (hashtable-ref cache path #f)])
	    (if cached
		(node-resource-set! node cached)
		(let ([entry (hashtable-ref data path #f)])
		  (if (or (eqv? entry 'loading) (pair? entry))
		      (hashtable-set! (manager-pending rm) node path)
		      (begin
			(hashtable-set! data path 'loading)
			(hashtable-set! (manager-pending rm) node path)
			(fork-thread
			 (lambda ()
			   (let ([result (fn rm path)])
			     (with-mutex lock
			       (if result
				   (hashtable-set! data path result)
				   (hashtable-delete! data path)))))))))))))))

  (define make-texture-node
    (lambda (rm id path)
      (let ([node (make-node id 'texture #f #f)])
	(load-async
	 rm node path
	 (lambda (rm path)
	   (let-values ([(ext data len) (ref rm path)])
	     (if data
		 (let ([img (LoadImageFromMemory ext data len)])
		   (list 'texture img))
		 #f))))
	node)))

  (define parse-bin-metadata
    (lambda (bv)
      (let ([map (make-hashtable (lambda (x) x) =)]
            [count (bytevector-s32-ref bv 0 (endianness little))]) ;; 读取头部的总字数
	(let loop ([i 0] [offset 4]) ;; 从第 4 字节开始读取每个字形的数据
          (if (< i count)
              (let ([cp  (bytevector-s32-ref bv offset (endianness little))]
                    [rx  (bytevector-ieee-single-ref bv (+ offset 4) (endianness little))]
                    [ry  (bytevector-ieee-single-ref bv (+ offset 8) (endianness little))]
                    [rw  (bytevector-ieee-single-ref bv (+ offset 12) (endianness little))]
                    [rh  (bytevector-ieee-single-ref bv (+ offset 16) (endianness little))]
                    [ox  (bytevector-s32-ref bv (+ offset 20) (endianness little))]
                    [oy  (bytevector-s32-ref bv (+ offset 24) (endianness little))]
                    [adv (bytevector-s32-ref bv (+ offset 28) (endianness little))])
		(hashtable-set! map cp 
				(vector (make-rectangle rx ry rw rh) ox oy adv))
		(loop (+ i 1) (+ offset 32)))
              map)))))
  
  (define make-char-node
    (lambda (rm id font-path char)
      (let ([node (make-node id 'char #f char)])
	(load-async
	 rm node font-path
	 (lambda (rm path)
	   (let*-values ([(a-ext a-data a-len) (ref rm (string-append path ".atlas"))]
			 [(b-ext b-data b-len) (ref rm (string-append path ".bin"))])
	     (if (and a-data b-data)
		 (let ([img (LoadImageFromMemory a-ext a-data a-len)]
		       [glyph-map (parse-bin-metadata b-data)])
		   (list 'font img glyph-map))
		 #f))))
	node)))

  (define make-text-node
    (lambda (id char-nodes spacing)
      (let* ([chars (map node-data char-nodes)]
	     [node (make-node id 'text #f (list->string chars))])
	(for-each
	 (lambda (n) (node-add! node n))
	 char-nodes)
	(node-customize-set!
	 node
	 (list (cons 'layout 'left)
	       (cons 'spacing spacing)))
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
		 (let ([entry (hashtable-ref data path #f)])
		   (when (pair? entry)
		     (let ([waiting-nodes (hashtable-ref path->nodes path '())]
			   (if (null? waiting-nodes)
			       (hashtable-delete! data path)
			       (case (car entry)
				 [(texture)
				  (let* ([img (cadr entry)]
					 [tex (LoadTextureFromImage img)])
				    (TraceLog LOG_INFO (format "RESOURCE: Uploading texture for ~a, nodes count: ~a" path (length waiting-nodes)))
				    (UnloadImage img)
				    (if (zero? (Texture-id tex))
					(TraceLog LOG_ERROR (format "RESOURCE: Failed to create texture from memory: ~a" path))
					(begin
					  (TraceLog LOG_INFO (format "RESOURCE: Texture uploaded: ~a (id=~a)" path (Texture-id tex)))
					  (hashtable-set! cache path tex)
					  (for-each
					   (lambda (node)
					     (node-resource-set! node tex)
					     (node-type-set! node 'texture)
					     (hashtable-delete! pending node))
					   waiting-nodes))))
				  ]
				 [(font)
				  (let* ([atlas (cadr entry)]
					 [glyph-map (caddr entry)]
					 [tex (LoadTextureFromImage atlas)])
				    (UnloadImage atlas)
				    (if (zero? (Texture-id tex))
					(TraceLog LOG_ERROR (format "RESOURCE: Failed to upload font texture: ~a" path))
					(begin
					  (SetTextureFilter tex 1)
					  (let ([font (cons tex glyph-map)])
					    (hashtable-set! cache path font)
					    (for-each
					     (lambda (node)
					       (node-resource-set! node font)
					       (node-type-set! node 'char)
					       (hashtable-delete! pending node))
					     waiting-nodes)))))
				  ]
				 [else
				  (TraceLog LOG_ERROR (format "RESOURCE: Unknown data type ~a" (car entry)))])
			       ))
		       (hashtable-delete! data path)))))
	       paths))))))
    )
  )
