(library (core picture)
  (export texture->picture beside above
	  rotate layer stroke fade cache
	  resize at origin msdf tint
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
		  ))))))
       ]
      [(tex)
       (let ([pic #f])
	 (lambda (fr)
	   (when (texture-pointer tex)
	     (unless pic
	       (set! pic
		     (texture->picture
		      tex (make-rectangle
			   0.0 0.0
			   (texture-width tex)
			   (texture-height tex))
		      )))
	     (pic fr))))
       ])
    )

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
	      (pic-a fr-a)
	      (pic-b fr-b)))))))

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
	      (pic-a fr-a)
	      (pic-b fr-b)))))))

  (define layer
    (lambda pics
      (lambda (fr)
	(for-each (lambda (p) (p fr)) pics))
      ))

  (define rotate
    (lambda (pic angle)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h acr ori (+ rot angle)))
	  ))))

  (define at
    (lambda (pic x y)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h (make-vector2
				(+ x (vector2-x acr))
				(+ y (vector2-y acr))) ori rot))
	  ))))

  (define origin
    (lambda (pic ox oy)
      (lambda (fr)
	(let ([w (frame-width fr)]
	      [h (frame-height fr)]
	      [acr (frame-anchor fr)]
	      [ori (frame-origin fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame w h acr
			   (make-vector2
			    (+ (vector2-x ori) ox)
			    (+ (vector2-y ori) oy)) rot))
	  ))))

  (define resize
    (lambda (pic w h)
      (lambda (fr)
	(let ([ori (frame-origin fr)]
	      [acr (frame-anchor fr)]
	      [rot (frame-rotation fr)])
	  (pic (make-frame (inexact w) (inexact h) acr ori rot))
	  ))))

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
	      (pic fr)
	      (line-pic top-fr)
	      (line-pic bottom-fr)
	      (line-pic left-fr)
	      (line-pic right-fr)))
	  ))))

  (define fade
    (lambda (pic alpha)
      (lambda (fr)
	(let ([local (color-alpha white alpha)])
	  (parameterize ([*TINT* (color-multiply (*TINT*) local)])
	    (pic fr))))
      ))

  (define cache
    (lambda (pic w h)
      (let ([rt (LoadRenderTexture w h)]
	    [cached #f])
	(lambda (fr)
	  (unless cached
	    (BeginTextureMode rt)
	    (ClearBackground (color->Color blank))
	    (pic (make-frame (inexact w)
			     (inexact (- h))
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
	  ))))

  (define msdf
    (lambda (pic)
      (unless SDF_SHADER
	(set! SDF_SHADER (LoadShader #f "assets/msdf.fs")))
      (lambda (fr)
	(BeginShaderMode SDF_SHADER)
	(pic fr)
	(EndShaderMode))))

  (define tint
    (lambda (pic c)
      (lambda (fr)
	(parameterize ([*TINT* c])
	  (pic fr)))))
  )
