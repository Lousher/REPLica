(library (game stage)
  (export hold loader
	  sequential change)
  (import
   (ffi raylib binding) ;basic
   (game resource) ; bundle
   (game picture)
   (chezscheme))

  #| stage 是 接收 bundle 并进行实际演出的函数 |#

  #| hold 是最简单的stage,持续在win上保持资源存在|#
  (define hold
    (lambda (res)
      (lambda (bun)
	(lambda (win)
	  (res win)))))
  
  #| loader 是特殊的stage，加载资源 |#
  (define loader
    (lambda (bun)
      (let* ([ress (bundle-resources bun)]
	     [texs (filter texture? ress)]
	     [mucs (filter music? ress)]
	     [texs-unload (filter (lambda (t) (not (texture-data t))) texs)]
	     [mucs-unload (filter (lambda (t) (not (music-data t))) mucs)])
	(lambda (win)
	  (for-each
	   (lambda (tex)
	     (let* ([name (texture-name tex)]
		    [t (LoadTexture name)])
	       (texture-data-set! tex t)))
	   texs-unload)
	  (for-each
	   (lambda (muc)
	     (let* ([name (music-name muc)]
		    [m (LoadMusicStream name)])
	       (music-data-set! muc m)))
	   mucs-unload)
	  ))))

  (define sequential
    (lambda sgs
      (lambda (bun)
	(lambda (win)
	  (for-each
	   (lambda (sg)
	     ((sg bun) win))
	   sgs)))))

  (define change
    (lambda (ev sg1 sg2)
      (let ([hanged sg1])
	(lambda (bun)
	  (lambda (win)
	    ((hanged bun) win)
	    (when (ev) (set! hanged sg2)))
	  ))))
  )
