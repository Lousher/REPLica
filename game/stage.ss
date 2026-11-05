(library (game stage)
  (export stage? stage-perform stage-deps
   hold 
   parallel change row column sequential toggle)
  (import
   (game resource)
   (game type)
   (game window)
   (game picture)
   (game clip)
   (chezscheme))

  (define-record-type stage
    (fields perform deps))
  #| stage 是 接收 res 并进行实际演出的函数 |#

    #| hold 是最简单的stage,持续在win上保持track |#
  (define hold
    (lambda (trk)
      (let ([all-deps '()] [done? #f] [last-deps #f]
	    [loaded (make-hashtable string-hash string=?)])
	(define load-and-collect
	  (lambda (deps)
	    (unless (eq? deps last-deps)
	      (for-each
	       (lambda (r)
		 (let ([k (resource->key r)])
		   (unless (hashtable-contains? loaded k)
		     (hashtable-set! loaded k #t)
		     (loader r))))
	       deps)
	      (set! all-deps (merge-deps all-deps deps))
	      (set! last-deps deps))))
	(make-stage
	 (lambda (win)
	   (cond
	    [done? #f]
	    [else
	     (let ([out (trk win)])
	       (cond
		[(not out) (set! done? #t) #f]
		[(eqv? (void) out) #t] ;delaying
		[(picture? out)
		 (load-and-collect (picture-deps out))
		 ((picture-drawer out) (window-frame win))
		 #t]
		[(clip? out)
		 (load-and-collect (clip-deps out))
		 ((clip-player out) (window-channel win))
		 #t]
		[else
		 (error 'hold "Unknow Resource Type" out)]))]))
	 (lambda () all-deps)))))

  (define (sequential . stages)
    (let ([idx 0])
      (make-stage
       (lambda (win)
         (if (>= idx (length stages))
             #f
             (let ([alive? ((stage-perform (list-ref stages idx)) win)])
               (if alive?
                   #t
                   (begin
                     (set! idx (+ idx 1))
                     #t)))))
       (lambda ()
         (apply merge-deps (map (lambda (s) ((stage-deps s))) stages))))))
  
  (define parallel
    (lambda sgs
      (make-stage
       (lambda (win)
	 (let loop ([rest sgs] [all-done? #t])
	   (if (null? rest)
	       (if all-done? #f #t)
	       (let ([r ((stage-perform (car rest)) win)])
		 (loop (cdr rest) (and all-done? (not r)))))))
       (lambda ()
	 (apply merge-deps (map (lambda (s) ((stage-deps s))) sgs))))))

  (define change
    (lambda (ev sg1 sg2)
      (let ([current sg1]
	    [switched? #f])
	(make-stage
	 (lambda (win)
	   (when (and (ev win) (not switched?))
	     (let* ([old-deps ((stage-deps current))]
		    [new-deps ((stage-deps sg2))])
	       (unless (null? new-deps)
		 (for-each unloader (resource-difference old-deps new-deps))))
	     (set! current sg2)
	     (set! switched? #t))
	   ((stage-perform current) win))
	 (lambda ()
	   (merge-deps ((stage-deps sg1)) ((stage-deps sg2))))))))
  
  #| loader 是特殊的stage builder，加载资源,bun 就是资源的list |#

  (define row
    (lambda sgs
      (make-stage
       (lambda (win)
	 (let* ([f (window-frame win)]
		[dest (frame-dest f)])
	   (let-values ([(x y w h) (rectangle-values dest)])
	     (let* ([n (length sgs)]
		    [sw (/ w n)])
	       (let loop ([rest sgs] [i 0] [all-done? #t])
		 (if (null? rest)
		     (if all-done? #f #t)
		     (let ([r ((stage-perform (car rest))
			       (window-change-frame
				win
				(frame-change-dest f (make-rectangle (+ x (* i sw)) y sw h))))])
		       (loop (cdr rest) (+ i 1) (and all-done? (not r))))))))))
       (lambda ()
	 (apply merge-deps (map (lambda (s) ((stage-deps s))) sgs))))))

  (define column
    (lambda sgs
      (make-stage
       (lambda (win)
         (let* ([f (window-frame win)]
                [dest (frame-dest f)])
           (let-values ([(x y w h) (rectangle-values dest)])
	     (let* ([n  (length sgs)]
		    [sh (/ h n)])
               (let loop ([rest sgs] [i 0] [all-done? #t])
                 (if (null? rest)
		     (if all-done? #f #t)
		     (let ([r ((stage-perform (car rest))
			       (window-change-frame
				win
				(frame-change-dest
				 f
				 (make-rectangle x (+ y (* i sh)) w sh))))])
                       (loop (cdr rest) (+ i 1) (and all-done? (not r))))))))))
       (lambda ()
         (apply merge-deps (map (lambda (s) ((stage-deps s))) sgs))))))

  (define (toggle ev sg1 sg2)
    (make-stage
     (lambda (win)
       (if (ev win)
           ((stage-perform sg2) win)
           ((stage-perform sg1) win)))
     (lambda ()
       (merge-deps ((stage-deps sg1)) ((stage-deps sg2))))))   ; ← 两个都合并，都预加载

  )
