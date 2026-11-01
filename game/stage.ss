(library (game stage)
  (export hold loader
	  sequential change)
  (import
   (ffi raylib binding) ;basic
   (game resource)
   (game type)
   (chezscheme))

  #| helper |#
  (define optimize-texture
    (lambda (T)
      (GenTextureMipmaps T)
      (SetTextureFilter T TEXTURE_FILTER_TRILINEAR)))
  
  (define Texture-width
    (lambda (T)
      (ftype-ref Texture (width) T)))
  (define Texture-height
    (lambda (T)
      (ftype-ref Texture (height) T)))

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
      (lambda (win)
	(let* ([ress (bundle-resources bun)]
	       [texs (filter texture? ress)]
	       [mucs (filter music? ress)]
	       [shs (filter shader? ress)]
	       [texs-unload (filter (lambda (t) (not (texture-data t))) texs)]
	       [mucs-unload (filter (lambda (t) (not (music-data t))) mucs)]
	       [shs-unload (filter (lambda (t) (not (shader-data t))) shs)])
	  (for-each
	   (lambda (tex)
	     (let* ([name (texture-name tex)]
		    [t (LoadTexture name)]
		    [w (Texture-width t)]
		    [h (Texture-height t)])
	       (optimize-texture t)
	       (texture-data-set! tex t)
	       (texture-source-set! tex (make-rectangle 0.0 0.0
							(inexact w)
							(inexact h)))
	       ))
	   texs-unload)
	  (for-each
	   (lambda (muc)
	     (let* ([name (music-name muc)]
		    [m (LoadMusicStream name)])
	       (music-data-set! muc m)))
	   mucs-unload)
	  (for-each
	   (lambda (sh)
	     (let* ([fs (shader-fs sh)]
		    [vs (shader-vs sh)]
		    [s (LoadShader fs vs)])
	       (unless (IsShaderValid s)
		 (error 'load (format "[Loader] ~a and ~a cannot load shader" fs vs)))
	       (shader-data-set! sh s)))
	   shs-unload)
	  ))))

  (define sequential
    (lambda sgs
      (lambda (bun)
	(let ([stages (map (lambda (sg) (sg bun)) sgs)])  ; 构造期算一次
          (lambda (win)
            (for-each (lambda (s) (s win)) stages))))))

  (define change
    (lambda (ev sg1 sg2)
      (let ([hanged sg1])
	(lambda (bun)
	  (lambda (win)
	    ((hanged bun) win)
	    (when (ev) (set! hanged sg2)))
	  ))))
  )
