(library (game stage)
  (export stage? stage-perform stage-deps
	  hold place zoom move spawn with
	  series change row column toggle together)
  (import
   (game resource)
   (game type)
   (game window)
   (game effect)
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
	     (let ([out (trk (window-timeline win))])
	       (cond
		[(not out) (set! done? #t) #f]
		[(eqv? (void) out) #t] ;delaying
		[(effect? out)
		 (load-and-collect (effect-deps out))
		 (call-with-values
		     (lambda () (window-values win))
		   (lambda ctxs
 		     (apply effect-execute! out ctxs)))]
		[else
		 (error 'hold "Unknow Resource Type" out)]))]))
	 (lambda () all-deps)))))

  (define (with effect-fn trk)
    (let ([inner-stage (hold trk)])
      (make-stage
       (lambda (win)
	 (effect-fn win)
	 ((stage-perform inner-stage) win))
       (lambda ()
	 ((stage-deps inner-stage))))))

  (define (toggle ev sg1 sg2)
    (make-stage
     (lambda (win)
       (if (ev win)
           ((stage-perform sg2) win)
           ((stage-perform sg1) win)))
     (lambda ()
       (merge-deps ((stage-deps sg1)) ((stage-deps sg2))))))
  
  (define (series . stages)
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
  
  (define together
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

  (define (spawn ev track-thunk base-stage)
    (let ([active '()])
      (make-stage
       (lambda (win)
	 (when (ev win)
           (set! active (cons (hold (track-thunk)) active)))
	 ;; 执行 + 清理死亡 stage
	 (set! active
               (filter (lambda (sg) ((stage-perform sg) win)) active))
	 ;; 基础舞台
	 ((stage-perform base-stage) win))
       (lambda ()
	 (apply merge-deps
		((stage-deps base-stage))
		(map (lambda (sg) ((stage-deps sg))) active))))))

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
  
  (define (place fn-dest inner-stage)
    (make-stage
     (lambda (win)
       (let* ([f (window-frame win)]
              [d (frame-dest f)]
              [x (rectangle-x d)]
              [y (rectangle-y d)]
              [w (rectangle-width d)]
              [h (rectangle-height d)])
	 (let-values ([(nx ny nw nh) (fn-dest x y w h)])
           ((stage-perform inner-stage)
            (window-change-frame win
				 (frame-change-dest f (make-rectangle nx ny nw nh)))))))
     (lambda ()
       ((stage-deps inner-stage)))))

  ;; 只改坐标
  (define (move fn-xy stage)
    (place (lambda (x y w h)
             (let-values ([(nx ny) (fn-xy x y)])
               (values nx ny w h)))
           stage))

  ;; 只改尺寸（左上角不动）
  (define (zoom times stage)
    (place (lambda (x y w h)
             (values x y (* w times) (* h times)))
           stage))

  )
