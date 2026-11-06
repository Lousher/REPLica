(library (game stage)
  (export stage? stage-perform stage-deps
	  show)
  (import
   (game effect)
   (game context)
   (only (game resource) resource->key loader merge-deps)
   (chezscheme))

  (define-record-type stage
    (fields perform deps))

  (define (show ani-trk)
    (let ([all-deps '()] [done? #f] [last-deps '()]
	  [loaded (make-hashtable string-hash string=?)])
      (define load-and-collect
	(lambda (deps)
	  (unless (eq? deps last-deps)
	    (for-each
	     (lambda (dep)
	       (let ([key (resource->key dep)])
		 (unless (hashtable-contains? loaded key)
		   (hashtable-set! loaded key #t)
		   (loader dep))))
	     deps)
	    (set! all-deps (merge-deps all-deps deps))
	    (set! last-deps deps))))
      (make-stage
       (lambda (ctx)
	 (if done?
             #f
             (context-fetch
	      ctx ([m MOMENT] [f FRAME])
	      (let* ([t (moment-uptime m)]
		     [out (ani-trk t)])
		(if out
		    (begin 
		      (load-and-collect (effect-deps out))
		      (effect-execute! out f)
		      #t)
		    (begin (set! done? #t) #f))))))
       (lambda () all-deps))))
  )
