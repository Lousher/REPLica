(library (game stage)
  (export stage? stage-perform stage-deps
   hold loader 
   parallel change row column)
  (import
   (game resource)
   (game type)
   (game window)
   (chezscheme))

  (define-record-type stage
    (fields perform deps))
  #| stage 是 接收 res 并进行实际演出的函数 |#

  #| hold 是最简单的stage,持续在win上保持timer?存在|#
  (define hold
    (lambda (timer)
      (let ([deps #f]
	    [loaded (make-hashtable string-hash string=?)])
	(make-stage
	 (lambda (win)
	   (let ([d (timer win)])
	     (unless deps (set! deps d))
	     (for-each
	      (lambda (r)
		(let ([k (resource->key r)])
		  (unless (hashtable-contains? loaded k)
		    (hashtable-set! loaded k #t)
		    (loader r))))
	      d)))
	 (lambda () (or deps '()))))))
  
  (define parallel
    (lambda sgs
      (make-stage
       (lambda (win)
         (for-each (lambda (s) ((stage-perform s) win)) sgs))
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
		    [new-deps ((stage-deps sg2))]
		    [to-release (resource-difference old-deps new-deps)])
	       (for-each unloader to-release))
	     (set! current sg2)
	     (set! switched? #t))
	   ((stage-perform current) win))
	 (lambda ()
	   (merge-deps (stage-deps sg1) (stage-deps sg2)))))))
  
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
	       (let loop ([rest sgs] [i 0])
		 (unless (null? rest)
		   ((stage-perform (car rest))
		    (window-change-frame
		     win
		     (frame-change-dest f (make-rectangle (+ x (* i sw)) y sw h))))
		   (loop (cdr rest) (+ i 1))))))))
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
               (let loop ([rest sgs] [i 0])
                 (unless (null? rest)
                   ((stage-perform (car rest))
		    (window-change-frame
		     win
		     (frame-change-dest
		      f
		      (make-rectangle x (+ y (* i sh)) w sh))))
                   (loop (cdr rest) (+ i 1))))))))
       (lambda ()
         (apply merge-deps (map (lambda (s) ((stage-deps s))) sgs))))))

  )
