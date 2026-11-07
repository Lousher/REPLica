(library (game stage)
  (export stage? stage-perform stage-deps
	  enact backstage together hold loading)
  (import
   (game effect)
   (game context)
   (only (game resource) resource->key loader merge-deps)
   (only (game track) prefetch)
   (chezscheme))

  (define-record-type stage
    (fields perform deps))

  (define tacet (make-stage (lambda (ctx) #f) (lambda () '())))

  (define loading
    (lambda (resource-trk)
      (lambda (t)
	(let ([deps (resource-trk t)])
	  (if deps
	      (begin (for-each loader deps) #t)
	      #f)))))

  (define (hold trk)
    (let ([done? #f]
	  [all-deps-so-far '()])
      (make-stage
       (lambda (ctx)
	 (if done?
             #f
             (context-fetch
	      ctx ([m MOMENT])
	      (let* ([t (moment-uptime m)]
		     [out (trk t)])
		(if out
		    (begin
		      (set! all-deps-so-far
			    (merge-deps all-deps-so-far
					(effect-deps out)))
		      (effect-execute! out ctx)
		      #t)
		    (begin (set! done? #t) #f))))))
       (lambda () all-deps-so-far))))
  
  (define PREFETCH_TIME 2)
  
  (define enact
    (lambda (trk)
      (let ([back (backstage (loading (prefetch PREFETCH_TIME trk)))]
	    [front (hold trk)])
	(together back front))))

  (define backstage
    (lambda (trk)			; t->bool
      (let ([done? #f])
	(make-stage
	 (lambda (ctx)
	   (if done? #f
	       (context-fetch
		ctx ([m MOMENT])
		(let ([t (moment-uptime m)])
		  (if (trk t) #t
		      (begin (set! done? #t) #f))
		  ))))
	 (lambda () '())))))

  (define together
    (lambda stages
      (make-stage
       (lambda (ctx)
	 (let ([results (map (lambda (stage) ((stage-perform stage) ctx)) stages)])
	   (and (pair? results)
		(for-all (lambda (s) s) results))))
       (lambda ()
	 (apply merge-deps
		(map
		 (lambda (s) ((stage-deps s)))
		 stages)))))))
