(library (core picture)
  (export texture->picture beside above
	  rotate layer stroke fade cache
	  resize at origin msdf tint
	  char->picture string->picture
	  backdrop widthwise heightwise
	  centred mask
	  *TINT*)
  (import
   (chezscheme)
   (render drawing)
   (core type)
   (core frame)
   (design color)
   (ffi raylib binding))

  (define *TINT* (make-parameter white))
  (define SDF_SHADER #f)

  (define texture->picture
    (case-lambda
      [(tex rect)
       (lambda (fr)
	 (when (texture-pointer tex)
	   (let ([w (frame-width fr)]
		 [h (frame-height fr)]
		 [anchor (frame-anchor fr)]
		 [origin (frame-origin fr)]
		 [rot (frame-rotation fr)]
		 [src (texture-source tex)]
		 [rect-x (rectangle-x rect)]
		 [rect-y (rectangle-y rect)]
		 [rect-w (rectangle-width rect)]
		 [rect-h (rectangle-height rect)]
		 )
	     (let ([acr-x (vector2-x anchor)]
		   [acr-y (vector2-y anchor)]
		   [flip-x? (negative? w)]
		   [flip-y? (negative? h)]
		   )
	       (let ([src-w (if flip-x? (- rect-w) rect-w)]
		     [src-h (if flip-y? (- rect-h) rect-h)]
		     [src-x (if flip-x? rect-w rect-x)]
		     [src-y (if flip-y? rect-h rect-y)])
		 (draw-texture-pro
		  tex
		  (make-rectangle
		   src-x src-y src-w src-h)
		  (make-rectangle
		   acr-x acr-y
		   (frame-width fr) (frame-height fr))
		  origin
		  (frame-rotation fr)
		  (*TINT*)
		  )))))
	 (values (texture-width tex)
		 (texture-height tex)))
       ]
      [(tex)
       (lambda (fr)
	 (let ([pic #f])
	   (when (texture-pointer tex)
	     (unless pic
	       (set! pic
		     (texture->picture
		      tex (make-rectangle
			   0.0 0.0
			   (texture-width tex)
			   (texture-height tex))
		      )))
	     (pic fr))
	   (values
	    (texture-width tex)
	    (texture-height tex))))
       ])
    )

  (define list-remove-last
    (lambda (lst)
      (cond
       [(null? list) '()]
       [(null? (cdr lst)) '()]
       [else (cons (car lst)
		   (list-remove-last (cdr lst)))])))
  
  (define string->picture
    (lambda (str font)
      (let* ([chars (string->list str)]
	     [cps (map char->integer chars)]
	     [charmap (font-charmap font)]
	     [glys (map charmap cps)]
	     [advs (map glyph-advance glys)])
	(let* ([xs-end (reverse (fold-left
				 (lambda (acc x)
				   (if (null? acc)
				       (list x)
				       (cons (+ x (car acc))
					     acc)))
				 '()
				 advs))]
	       [w-total (car (last-pair xs-end))]
	       [ws-ratio (map (lambda (w) (/ w w-total)) advs)]
	       [xs-start (cons 0.0 (list-remove-last xs-end))]
	       [xs-ratio (map (lambda (x) (/ x w-total)) xs-start)])
	  (lambda (fr)
	    (let ([w (frame-width fr)]
		  [h (frame-height fr)]
		  [acr (frame-anchor fr)]
		  [ori (frame-origin fr)]
		  [rot (frame-rotation fr)])
	      (let ([char-pics (map (lambda (ch) (char->picture ch font)) chars)]
		    [char-frs (map
			       (lambda (x-ratio w-ratio)
				 (make-frame
				  (* w-ratio w) h
				  acr
				  (make-vector2
				   (- (vector2-x ori) (* x-ratio w))
				   (vector2-y ori)
				   )
				  rot
				  ))
			       xs-ratio
			       ws-ratio)])
		(let ([vals (map (lambda (pic fr)
				   (call-with-values
				       (lambda () (pic fr))
				     list))
				 char-pics char-frs)])
		  (let ([res (apply map list vals)])
		    (values (apply + (car res))
			    (apply max (cadr res)))))
		)))
	  )
	)
      ))
  
  (define char->picture
    (lambda (ch font)
      (let* ([cp (char->integer ch)]
	     [meta (font-metadata font)]
	     [sprite (font-sprite font)]
	     [charmap (font-charmap font)]
	     [size (atlas-size (font-meta-atlas meta))]
	     [asc (metrics-ascender (font-meta-metrics meta))]
	     [line-h (metrics-line-height (font-meta-metrics meta))]
	     [gly (charmap cp)]
	     [adv (glyph-advance gly)]
	     [ple (glyph-plane gly)])
	(let* ([left (plane-left ple)]
	       [right (plane-right ple)]
	       [bottom (plane-bottom ple)]
	       [top (plane-top ple)])
	  (lambda (fr)
	    (let ([w (frame-width fr)]
		  [h (frame-height fr)])
	      (let ([scale (min (/ w adv) (/ h line-h))])
		(let ([pic-w (* (- right left) scale)]
		      [pic-h (* (- top bottom) scale)]
		      [offset-x (* left scale)]
		      [offset-y (- (* bottom scale) (* asc scale))])
		  ((at
		    (resize
		     (texture->picture
		      sprite (glyph-coord gly))
		     (lambda (w)
		       pic-w)
		     (lambda (h)
		       pic-h))
		    (lambda (x) (+ x offset-x))
		    (lambda (y) (+ y offset-y)))
		   fr)
		  (values (* size adv) (* size line-h)))))))
	)))
  
  (define beside
    (lambda (pic-a pic-b ratio)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (let ([acr-x (vector2-x acr)]
		[acr-y (vector2-y acr)]
		[ori-x (vector2-x ori)]
		[ori-y (vector2-y ori)])
	    (let ([fr-a (make-frame (* w ratio) h acr ori rot)]
		  [fr-b (make-frame (* w (- 1 ratio)) h acr
				    (make-vector2
				     (- ori-x (* w ratio))
				     ori-y)
				    rot)])
	      (let-values ([(aw ah) (pic-a fr-a)]
			   [(bw bh) (pic-b fr-b)])
		(values (+ aw bw) (max ah bh)))))))))

  (define above
    (lambda (pic-a pic-b ratio)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (let ([acr-x (vector2-x acr)]
		[acr-y (vector2-y acr)]
		[ori-x (vector2-x ori)]
		[ori-y (vector2-y ori)])
	    (let ([fr-a (make-frame w (* h ratio) acr ori rot)]
		  [fr-b (make-frame w (* h (- 1 ratio)) acr
				    (make-vector2
				     ori-x
				     (- ori-y (* h ratio))
				     )
				    rot)])
	      (let-values ([(aw ah) (pic-a fr-a)]
			   [(bw bh) (pic-b fr-b)])
		(values (max aw bw)
			(+ ah bh)))))))))

  (define layer
    (lambda pics
      (lambda (fr)
	(let ([vals (map (lambda (pic)
			   (call-with-values
			       (lambda () (pic fr))
			     list))
			 pics)])
	  (let ([res (apply map list vals)])
	    (values (apply max (car res))
		    (apply max (cadr res)))))
	)
      ))

  (define rotate
    (lambda (pic angle-f)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h acr ori (angle-f rot)))
	  ))))

  (define at
    (lambda (pic x-f y-f)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h (make-vector2
				(x-f (vector2-x acr))
				(y-f (vector2-y acr))) ori rot))
	  ))))
  
  (define origin
    (lambda (pic ox-f oy-f)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h acr
			   (make-vector2
			    (ox-f (vector2-x ori))
			    (oy-f (vector2-y ori))) rot))
	  ))))
  
  (define resize
    (lambda (pic w-f h-f)
      (let ([w-fn (if w-f w-f (lambda (w) w))]
	    [h-fn (if h-f h-f (lambda (h) h))])
	(lambda (fr)
	  (let ([w (frame-width fr)]
		[h (frame-height fr)]
		[ori (frame-origin fr)]
		[acr (frame-anchor fr)]
		[rot (frame-rotation fr)])
	    (pic (make-frame
		  (inexact (w-fn w))
		  (inexact (h-fn h)) acr ori rot))
	    )))))

  (define stroke
    (lambda (pic thickness color)
      (lambda (fr)
	(let ([c-tex (color->texture color 1 1)]
	      [w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)]
	      [thick (* 1.0 thickness)])
	  (let ([x (vector2-x ori)]
		[y (vector2-y ori)]
		[acr-x (vector2-x acr)]
		[acr-y (vector2-y acr)]
		[line-pic (texture->picture c-tex)])
	    (let ([top-fr (make-frame
			   w thick
			   acr ori rot)]
		  [bottom-fr (make-frame
			      w thick
			      acr
			      (make-vector2 x (+ y (- thick h)))
			      rot)]
		  [left-fr (make-frame
			    thick h
			    acr ori rot)]
		  [right-fr (make-frame
			     thick h
			     acr (make-vector2 (+ x (- thick w)) y)
			     rot)])
	      (let-values ([(pic-w pic-h) (pic fr)])
		(line-pic top-fr)
		(line-pic bottom-fr)
		(line-pic left-fr)
		(line-pic right-fr)
		(values pic-w pic-h))))
	  ))))

  (define fade
    (lambda (pic alpha)
      (lambda (fr)
	(let ([local (color-alpha white alpha)])
	  (parameterize ([*TINT* (color-multiply (*TINT*) local)])
	    (pic fr)))
	)
      ))

  (define cache
    (lambda (pic)
      (let ([rt #f]
	    [cached #f])
	(let-values ([(rw rh) (pic (make-frame 0.0 0.0 (make-vector2 0.0 0.0) (make-vector2 0.0 0.0) 0.0))])
	  (lambda (fr)
	    (unless rt (set! rt (LoadRenderTexture
				 (exact (round rw))
				 (exact (round rh)))))
	    (unless cached
	      (BeginTextureMode rt)
	      (ClearBackground (color->Color blank))
	      (pic (make-frame (inexact rw)
			       (inexact (- rh))
			       (make-vector2 0.0 0.0)
			       (make-vector2 0.0 0.0)
			       0.0))
	      (EndTextureMode)
	      (let* ([img (LoadImageFromTexture (ftype-&ref RenderTexture2D (texture) rt))]
		     [tex (LoadTextureFromImage img)])
		(UnloadImage img)
		(UnloadRenderTexture rt)
		(set! cached
		      (texture->picture
		       (make-texture
			"rt cache" tex
			)))))
	    (cached fr)
	    (values rw rh)
	    )))))

  (define msdf
    (lambda (pic font)
      (unless SDF_SHADER
	(let* ([sh (LoadShader #f "assets/msdf.fs")]
	       [loc (GetShaderLocation sh "pxRange")]
	       [ptr (foreign-alloc (ftype-sizeof float))])
	  (foreign-set!
	   'float ptr 0
	   (inexact (atlas-distance-range (font-meta-atlas font))))
	  (SetShaderValue sh loc ptr SHADER_UNIFORM_FLOAT)
	  (set! SDF_SHADER sh)))
      (lambda (fr)
	(BeginShaderMode SDF_SHADER)
	(let-values ([(pic-w pic-h) (pic fr)])
	  (EndShaderMode)
	  (values pic-w pic-h))
	)))

  (define tint
    (lambda (pic c)
      (lambda (fr)
	(parameterize ([*TINT* c])
	  (pic fr))
	)))

  (define backdrop
    (lambda (pic color)
      (let* ([c-tex (color->texture color 1 1)]
	     [c-pic (texture->picture c-tex)])
	(lambda (fr)
	  (let-values ([(w h) (pic fr)])
	    (c-pic fr)
	    (pic fr)))
	)))

  (define centred
    (lambda (pic)
      (let-values ([(rw rh)
		    (pic (make-frame 0.0 0.0
				     (make-vector2 0.0 0.0)
				     (make-vector2 0.0 0.0)
				     0.0))])
	(lambda (fr)
	  (let ([w (frame-width fr)]
		[h (frame-height fr)]
		[acr (frame-anchor fr)]
		[rot (frame-rotation fr)]
		[wh-ration (/ rw rh)])
	    (pic (make-frame w h acr
			     (make-vector2 (/ w 2)
					   (/ h 2))
			     rot)))))))

  (define widthwise
    (case-lambda
      [(pic progress)
       (lambda (fr)
	 (let ([h (frame-height fr)]
	       [acr (frame-anchor fr)]
	       [ori (frame-origin fr)]
	       [rot (frame-rotation fr)])
	   (let-values ([(rw rh) (pic (make-frame 0.0 0.0 acr ori rot))])
	     (let* ([ratio (if (zero? rh) 0.0 (/ rw rh))]
		    [target-w (* progress (* h ratio))])
	       (pic (make-frame target-w h acr ori rot))
	       (values target-w h)))
	   )
	 )]
      [(pic)
       (widthwise pic 1)]))

  (define heightwise
    (lambda (pic)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (let-values ([(rw rh) (pic (make-frame 0.0 0.0 acr ori rot))])
	    (let* ([ratio (if (zero? rw) 0.0 (/ rh rw))]
		   [target-h (* w ratio)])
	      (pic (make-frame w target-h acr ori rot))
	      (values w target-h)))
	  ))))

  (define mask
    (let ([dissolve-sh #f]
          [progress-loc #f]
          [texture1-loc #f]
          ;; 1. 将 C 指针提升到外层闭包，彻底避免内存泄漏
          [progress-ptr (foreign-alloc (ftype-sizeof float))]) 
      (case-lambda
	[(pic masked pr)
	 ;; 2. 初始化 Shader 以及一次性提取 Location
	 (unless dissolve-sh
           (set! dissolve-sh (LoadShader #f "assets/mask/dissolve.fs"))
           (set! progress-loc (GetShaderLocation dissolve-sh "progress"))
           (set! texture1-loc (GetShaderLocation dissolve-sh "texture1")))
	 (let ([rt #f])
	   ;; 3. 注意：这里不再在内部持久化单个 rt 
	   ;; 建议从你的全局 RenderTexture 资源池中动态租借/归还
	   (lambda (fr)
             (let* ([fw (frame-width fr)]
		    [fh (frame-height fr)]
		    [w (exact (round fw))]
                    [h (exact (round fh))]
                    ;; 假设你有一个全局租借函数，没有的话就每帧 Create/Unload（但性能差点）
		    )
               (unless rt (set! rt (LoadRenderTexture w h))
		       (BeginTextureMode rt)
		       (masked (make-frame fw fh (make-vector2 0.0 0.0)
					   (make-vector2 0.0 0.0) 0.0)) 
		       (EndTextureMode)


		       )
               ;; 4. 离屏绘制 Mask（注意：masked 应该吃画布局部的满铺 frame，而不是外层世界坐标 fr！）
               
               ;; 5. 激活着色器并塞入参数
               (BeginShaderMode dissolve-sh)
               (foreign-set! 'float progress-ptr 0 pr)
               (SetShaderValue dissolve-sh progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	       (let ([masked-tex (ftype-&ref RenderTexture2D (texture) rt)])
		 (SetTextureFilter masked-tex TEXTURE_FILTER_POINT)
		 (SetShaderValueTexture dissolve-sh texture1-loc masked-tex))
               
               ;; 这里的 ftype-&ref 提取没有问题

               (pic fr)
               (EndShaderMode)
               ;; 7. 渲染完立刻归还临时画布，避免显存爆炸
	       )))]
	[(pic masked)
	 (mask pic masked 0.0)])))

  )
