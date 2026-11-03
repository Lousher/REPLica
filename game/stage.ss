(library (game stage)
  (export stage? stage-perform stage-deps
   hold loader
   parallel change)
  (import
   (game resource)
   (game type)
   (chezscheme))

  (define-record-type stage
    (fields perform deps))
  #| stage 是 接收 res 并进行实际演出的函数 |#

  #| hold 是最简单的stage,持续在win上保持timer?存在|#
  (define hold
    (lambda (timer)
      (let ([deps #f])
	(make-stage
	 (lambda (win)
	   (let ([d (timer win)])
	     (unless deps (set! deps d))
	     (loader d)))
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
      (let ([current sg1])
	(make-stage
	 (lambda (win)
	   (when (ev)
	     (let* ([old-deps ((stage-deps current))]
		    [new-deps ((stage-deps sg2))]
		    [to-release (resource-difference old-deps new-deps)])
	       (unloader to-release))
	     (set! current sg2))
	   ((stage-perform current) win))
	 (lambda ()
	   (merge-deps (stage-deps sg1) (stage-deps sg2)))))))
  
  #| loader 是特殊的stage builder，加载资源,bun 就是资源的list |# 

  )
