(library (game stage)
  (export stage? stage-perform stage-deps
	  enact backstage together hold loading
	  place slot branch)
  (import
   (game effect)
   (game context)
   (only (game resource) resource->key loader merge-deps)
   (only (game track) prefetch)
   (game type)
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

  (define place
    (lambda (fn-dest inner)
      (make-stage
       (lambda (ctx)
	 (context-fetch
	  ctx ([f FRAME] [mou MOUSE])
	  (let ([d (frame-dest f)])
	    (call-with-values
		(lambda () (rectangle-values d))
	      (lambda (x y w h)
		(let-values ([(nx ny nw nh) (fn-dest x y w h)])
		  (context-let
		   ctx ([FRAME (frame-change-dest f (make-rectangle nx ny nw nh))])
		   ((stage-perform inner) ctx))))))))
       (stage-deps inner))))

  (define slot
    (lambda (x y w h inner)
      (place
       (lambda (px py pw ph)
	 (values (+ px (* x pw))
		 (+ py (* y ph))
		 (* w pw)
		 (* h ph)))
       inner)))

  (define (hold trk)
    (let ([done? #f] [started #f]
	  [all-deps-so-far '()])
      (make-stage
       (lambda (ctx)
	 (if done?
             #f
             (context-fetch
	      ctx ([m MOMENT])
	      (let ([t (moment-uptime m)])
		(unless started (set! started t))
		(let* ([rt (- t started)]
		       [out (trk rt)])
		  (if out
		      (begin
			(set! all-deps-so-far
			      (merge-deps all-deps-so-far
					  (effect-deps out)))
			(effect-execute! out ctx)
			#t)
		      (begin (set! done? #t) #f)))))))
       (lambda () all-deps-so-far))))
  
  (define PREFETCH_TIME 3)
  
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

  #| map 是乱序！ |#
  (define together
    (lambda stages
      (make-stage
       (lambda (ctx)
	 (let loop ([ss stages] [all-alive? #t] [any? #f])
	   (if (null? ss)
	       (and any? all-alive?)
	       (let ([alive? ((stage-perform (car ss)) ctx)])
		 (loop (cdr ss)
		       (and all-alive? alive?)
		       (or any? alive?))))))
       (lambda ()
	 (apply merge-deps
		(map
		 (lambda (s) ((stage-deps s)))
		 stages))))))

  (define branch
    (lambda (pred deft altr)
      (let ([current deft])
	(make-stage
	 (lambda (ctx)
	   (if (pred ctx)
	       (begin
		 (set! current altr)
		 ((stage-perform altr) ctx))
	       (begin
		 (set! current deft)
		 ((stage-perform deft) ctx))))
	 (lambda ()
	   ((stage-deps current)))))))

  )


