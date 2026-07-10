(library (core picture)
  (export texture->picture 
	  stroke fade cache
	  msdf tint
	  char->picture string->picture
	  backdrop widthwise heightwise
	  centred mask-alpha
	  layer letterbox
	  *TINT*)
  (import
   (chezscheme)
   (render drawing)
   (core type)
   (core frame)
   (core layout)
   (design color)
   (engine loader)
   (ffi raylib binding))

					; picture is a procedure that inputs given frame, output picture's read width & height, with suitable drawing sideeffects on given frame.
  (define *TINT* (make-parameter white))
  (define SDF_SHADER #f)

  (define texture->picture
    (case-lambda
      [(tex rect)
       (case-lambda
	 [(fr)
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
		   )))))]
	 [()
	  (values (texture-width tex)
		  (texture-height tex))])
       ]
      [(tex)
       (case-lambda
	 [(fr)
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
	      (pic fr)))]
	 [()
	  (values
	   (texture-width tex)
	   (texture-height tex))])
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
	  (let ([char-pics (map (lambda (ch) (char->picture ch font)) chars)])
	    (case-lambda
	      [(fr)
	       (let ([w (frame-width fr)]
		     [h (frame-height fr)]
		     [acr (frame-anchor fr)]
		     [ori (frame-origin fr)]
		     [rot (frame-rotation fr)])
		 (let (
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
		   (for-each (lambda (pic fr) (pic fr))
			     char-pics char-frs)
		   ))]
	      [()
	       (let ([vals (map (lambda (pic)
				  (call-with-values
				      (lambda () (pic))
				    list))
				char-pics)])
		 (let ([res (apply map list vals)])
		   (values (apply + (car res))
			   (apply max (cadr res)))))
	       ]))
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
	  (case-lambda
	    [(fr)
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
		   )))]
	    [()
	     (values (* size adv) (* size line-h))
	     ]))
	)))

  (define stroke
    (lambda (pic thickness color)
      (case-lambda
	[(fr)
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
	       (pic fr)
	       (line-pic top-fr)
	       (line-pic bottom-fr)
	       (line-pic left-fr)
	       (line-pic right-fr)
	       ))
	   )]
	[()
	 (pic)])))

  (define fade
    (lambda (pic alpha)
      (case-lambda
	[(fr)
	 (let ([local (color-alpha white alpha)])
	   (parameterize ([*TINT* (color-multiply (*TINT*) local)])
	     (pic fr)))]
	[() (pic)])))

  (define cache
    (lambda (pic)
      (let ([rt #f]
	    [cached #f])
	(let-values ([(rw rh) (pic)])
	  (case-lambda
	    [(fr)
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
	     (cached fr)]
	    [()
	     (values rw rh)]
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
      (case-lambda
	[(fr)
	 (BeginShaderMode SDF_SHADER)
	 (pic fr)
	 (EndShaderMode)
	 ]
	[()
	 (pic)]
	)))

  (define tint
    (lambda (pic c)
      (case-lambda
	[(fr)
	 (parameterize ([*TINT* c])
	   (pic fr))]
	[() (pic)]
	)))

  (define backdrop
    (lambda (pic color)
      (let* ([c-tex (color->texture color 1 1)]
	     [c-pic (texture->picture c-tex)])
	(case-lambda
	  [(fr)
	   (c-pic fr)
	   (pic fr)]
	  [() (pic)])
	)))

  (define centred
    (lambda (pic)
      (case-lambda
	[(fr)
	 (let ([w (frame-width fr)]
	       [h (frame-height fr)]
	       [acr (frame-anchor fr)]
	       [rot (frame-rotation fr)]
	       )
	   (pic (make-frame w h acr
			    (make-vector2 (/ w 2)
					  (/ h 2))
			    rot)))]
	[() (pic)])))

  (define widthwise
    (lambda (pic)
      (let-values ([(rw rh) (pic)])
	(case-lambda
	  [(fr)
	   (let* ([h (frame-height fr)]
		  [ratio (if (zero? rh) 0.0 (/ rw rh))]
		  [acr (frame-anchor fr)]
		  [ori (frame-origin fr)]
		  [rot (frame-rotation fr)]
		  [target-w (* h ratio)])
	     (pic (make-frame target-w h acr ori rot))
	     )]
	  [()
	   (values rw rh)]
	  ))
      ))

  (define heightwise
    (lambda (pic)
      (let-values ([(rw rh) (pic)])
	(case-lambda
	  [(fr)
	   (let* ([ratio (if (zero? rw) 0.0 (/ rh rw))]
		  [w (frame-width fr)]
		  [acr (frame-anchor fr)]
		  [ori (frame-origin fr)]
		  [rot (frame-rotation fr)]
		  [target-h (* w ratio)])
	     (pic (make-frame w target-h acr ori rot))
	     )]
	  [()
	   (values rw rh)]
	  ))
      ))

					; May need refactor
  (define mask-alpha
    (let ([sh #f]
	  [tex1-loc #f]
	  [threshold-loc #f]
	  [threshold-ptr (foreign-alloc (ftype-sizeof float))]
	  )
      (lambda (pic path threshold)
	(let ([mask-tex (load-texture path)])
	  (foreign-set! 'float threshold-ptr 0 threshold)
	  (case-lambda
	    [(fr)
	     (unless sh
	       (set! sh (LoadShader #f "assets/shaders/mask.alpha.fs"))
	       (set! tex1-loc (GetShaderLocation sh "texture1"))
	       (set! threshold-loc (GetShaderLocation sh "threshold")))
	     (when (texture-pointer mask-tex)
	       (BeginShaderMode sh)
	       (SetShaderValue sh threshold-loc threshold-ptr SHADER_UNIFORM_FLOAT)
	       (SetShaderValueTexture sh tex1-loc (texture-pointer mask-tex)))
	     (pic fr)
	     (EndShaderMode)
	     ]
	    [()
	     (pic)]
	    )))))

					; using reverse just for temp!
  (define layer
    (lambda pics
      (case-lambda
	[(fr)
	 (for-each
	  (lambda (pic) (pic fr))
	  pics)]
	[()
	 (let ([vals (map (lambda (pic)
			    (call-with-values
				(lambda () (pic))
			      list))
			  pics
			  )])
	   (let ([recs (apply map list vals)])
	     (values (apply max (car recs))
		     (apply max (cadr recs)))))]
	)
      ))

  (define letterbox
    (case-lambda
      [(pic ratio c)
       (let ([c-pic (texture->picture (color->texture c 1 1))]
	     [trans (texture->picture (color->texture blank 1 1))]
	     [box-h-ratio (/ (- 1 ratio) 2)])
	 (case-lambda
	   [(fr)
	    ((layer
	      pic
	      (above
	       (above c-pic trans box-h-ratio)
	       c-pic
	       (- 1 box-h-ratio)
	       )
	      ) fr)]
	   [() (pic)]
	   ))]
      [(pic ratio)
       (letterbox pic ratio black)])
    )
  )
