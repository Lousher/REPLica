(library (game stage)
  (export static loader play
	  sequential latch)
  (import
   (ffi raylib binding)
   (game resource)
   (chezscheme))

  (define c (make-ftype-pointer Color (foreign-alloc (ftype-sizeof Color))))
  
  #| stage 是 接收 bundle 并进行实际演出的函数 |#

  #| static 是最简单的stage,将bundle内所有texture资源静态绘制|#
  (define static
    (lambda (bun)
      (let* ([ress (bundle-resources bun)]
	     [texs (filter texture? ress)])
	(ftype-set! Color (r) c 255)
	(ftype-set! Color (g) c 255)
	(ftype-set! Color (b) c 255)
	(ftype-set! Color (a) c 255)
	(lambda ()
	  (for-each
	   (lambda (tex)
	     (ClearBackground c)
	     (DrawTexture (texture-data tex) 0 0 c))
	   texs)))))
  
  #| play 播放所有 music|#
  (define play
    (lambda (bun)
      (let* ([ress (bundle-resources bun)]
	     [mucs (filter music? ress)])
	(lambda ()
	  (for-each
	   (lambda (muc)
	     (let ([m (music-data muc)])
	       (if (IsMusicStreamPlaying m)
		   (UpdateMusicStream m)
		   (PlayMusicStream m))))
	   mucs)))))
  
  #| loader 是特殊的stage，加载资源 |#
  (define loader
    (lambda (bun)
      (let* ([ress (bundle-resources bun)]
	     [texs (filter texture? ress)]
	     [mucs (filter music? ress)]
	     [texs-unload (filter (lambda (t) (not (texture-data t))) texs)]
	     [mucs-unload (filter (lambda (t) (not (music-data t))) mucs)])
	(lambda ()
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
	(lambda ()
	  (for-each
	   (lambda (sg)
	     ((sg bun)))
	   sgs)))))

  (define latch
    (lambda (ev sg)
      (let ([hanged #f])
	(lambda (bun)
	  (lambda ()
	    (when hanged ((hanged bun)))
	    (when (ev) (set! hanged sg)))
	  ))))
  )
