(library (game stage)
  (export hold loader
	  sequential change)
  (import
   (game resource)
   (game type)
   (chezscheme))


  #| stage 是 接收 res 并进行实际演出的函数 |#

  #| hold 是最简单的stage,持续在win上保持资源存在|#
  (define hold
    (lambda (res)
      (lambda (win)
	(loader (res win)))))
  
  (define sequential
    (lambda sgs
      (lambda (win)
        (for-each (lambda (s) (s win)) sgs))))

  (define change
    (lambda (ev sg1 sg2)
      (let ([hanged sg1])
	(lambda (win)
	  (hanged win)
	  (when (ev) (set! hanged sg2))))))
  
  #| loader 是特殊的stage builder，加载资源,bun 就是资源的list |# 

  )
