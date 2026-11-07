(library (game stage)
  (export stage? stage-perform stage-deps
	  enact backstage together hold loading tacet
	  place slot branch listen)
  (import
   (game effect)
   (game context)
   (only (game resource) resource->key loader merge-deps)
   (only (game track) prefetch)
   (game type)
   (chezscheme))

  (define-record-type stage
    (fields perform deps))

  #| stage-perform -> ctx -> (values alive? (list (sub-ctx . effect) ...))|#
  (define tacet
    (make-stage
     (lambda (ctx) (values #f '()))
     (lambda () '())))

  (define (hold trk)
    (let ([done? #f] [started #f]
	  [all-deps-so-far '()])
      (make-stage
       (lambda (ctx)
	 (if done?
             (values #f '())
             (context-fetch
	      ctx ([m MOMENT])
	      (let ([t (moment-uptime m)])
		(unless started (set! started t))
		(let* ([rt (- t started)] [out (trk rt)])
		  (if out
		      (begin
			(set! all-deps-so-far
			      (merge-deps all-deps-so-far
					  (effect-deps out)))
			(values #t (list (cons out ctx))))
		      (begin (set! done? #t) (values #f '()))))))))
       (lambda () all-deps-so-far))))

  (define together
    (lambda stages
      (make-stage
       (lambda (ctx)
	 (let loop ([ss stages] [any? #f] [scene '()])
	   (if (null? ss)
	       (values any? scene)
	       (call-with-values
		   (lambda () ((stage-perform (car ss)) ctx))
		 (lambda (alive? sc)
		   (loop (cdr ss) (or any? alive?) (append scene sc)))))))
       (lambda ()
	 (apply merge-deps
		(map
		 (lambda (s) ((stage-deps s)))
		 stages))))))

  (define (listen ev action)
    (let ([fired? #f])
      (make-stage
       (lambda (ctx)
	 (unless fired?
           (when (ev ctx)
             (action ctx)
             (set! fired? #t)))
	 (values (not fired?) '()))
       (lambda () '()))))

  (define branch
    (lambda (pred then else)
      (let ([current then])
	(make-stage
	 (lambda (ctx)
	   (set! current (if (pred ctx) then else))
	   ((stage-perform current) ctx))
	 (lambda () ((stage-deps current)))))))

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
		  (let ([inner-ctx
			 (context-with
			  ctx [FRAME (frame-change-dest f (make-rectangle nx ny nw nh))])])
		    (call-with-values
			(lambda () ((stage-perform inner) inner-ctx))
		      (lambda (alive? scene)
			(values alive?
				(map (lambda (it)
				       (if (pair? it) it
					   (cons it inner-ctx)))
				     scene)))))))))))
       (stage-deps inner))))

  (define backstage
    (lambda (trk)			; t->bool
      (let ([done? #f])
	(make-stage
	 (lambda (ctx)
	   (if done? #f
	       (context-fetch
		ctx ([m MOMENT])
		(let ([t (moment-uptime m)])
		  (if (trk t) (values #t '())
		      (begin (set! done? #t)
			     (values #f '())))))))
	 (lambda () '())))))

  (define loading
    (lambda (resource-trk)
      (lambda (t)
	(let ([deps (resource-trk t)])
	  (if deps
	      (begin (for-each loader deps) #t)
	      #f)))))

  (define slot
    (lambda (x y w h inner)
      (place
       (lambda (px py pw ph)
	 (values (+ px (* x pw))
		 (+ py (* y ph))
		 (* w pw)
		 (* h ph)))
       inner)))
  
  (define PREFETCH_TIME 3)
  
  (define enact
    (lambda (trk)
      (let ([back (backstage (loading (prefetch PREFETCH_TIME trk)))]
	    [front (hold trk)])
	(together back front))))



  #| map 是乱序！ |#


  



  )


