(library (scene renderer)
  (export render init-renderer uninit-renderer)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node))

  (define *sdf-shader* #f)

  (define init-renderer
    (lambda (sdf-path)
      (set! *sdf-shader* (LoadShader #f sdf-path))
      (if *sdf-shader*
	  (TraceLog LOG_INFO "RESOURCE: SDF shader loaded successfully")
	  (TraceLog LOG_ERROR "RESOURCE: Failed to load SDF shader"))))

  (define uninit-renderer
    (lambda ()
      (when *sdf-shader*
	(UnloadShader *sdf-shader*)
	(set! *sdf-shader* #f))))

  (define draw-texture-pro
    (let ([source-rect (make-Rectangle 0.0 0.0 0.0 0.0)]
	  [dest-rect (make-Rectangle 0.0 0.0 0.0 0.0)]
	  [origin-vec (make-Vector2 0.0 0.0)]
	  [color (make-Color 255 255 255 255)])
      (lambda (texture source dest origin rotation tint)
	(let ([src-x (list-ref source 0)]
	      [src-y (list-ref source 1)]
	      [src-w (list-ref source 2)]
	      [src-h (list-ref source 3)])
	  (Rectangle-x-set! source-rect (inexact src-x))
	  (Rectangle-y-set! source-rect (inexact src-y))
	  (Rectangle-width-set! source-rect (inexact src-w))
	  (Rectangle-height-set! source-rect (inexact src-h)))
	(let ([dst-x (list-ref dest 0)]
              [dst-y (list-ref dest 1)]
              [dst-w (list-ref dest 2)]
              [dst-h (list-ref dest 3)])
          (Rectangle-x-set! dest-rect (inexact dst-x))
          (Rectangle-y-set! dest-rect (inexact dst-y))
          (Rectangle-width-set! dest-rect (inexact dst-w))
          (Rectangle-height-set! dest-rect (inexact dst-h)))
	(let ([origin-x (list-ref origin 0)]
	      [origin-y (list-ref origin 1)])
	  (Vector2-x-set! origin-vec (inexact origin-x))
	  (Vector2-y-set! origin-vec (inexact origin-y)))
	(let ([r (list-ref tint 0)]
	      [g (list-ref tint 1)]
	      [b (list-ref tint 2)]
	      [a (list-ref tint 3)])
	  (Color-r-set! color r)
	  (Color-g-set! color g)
	  (Color-b-set! color b)
	  (Color-a-set! color a))
	(DrawTexturePro texture source-rect dest-rect origin-vec (inexact rotation) color))))

  (define render-node
    (lambda (node)
      (when (node-visible? node)
	(let ([type (node-type node)])
	  (case type
	    [(root) #f]
	    [(text)
	     (let loop ([children (reverse (node-children node))] (x 0.0))
	       (unless (null? children)
		 (let* ([char-node (car children)]
			[font (node-resource char-node)])
		   (if (and font (pair? font))   ; 检查字体是否就绪
		       (let* ([glyph-map (cdr font)]
			      [ch (node-data char-node)]
			      [cp (char->integer ch)]
			      [info (hashtable-ref glyph-map cp #f)]
			      [adv (if info (vector-ref info 3) 0)])
			 ;; 设置 char 节点相对于 text 节点的局部坐标
			 (node-x-set! char-node x)
			 (node-y-set! char-node 0)
			 ;; 递归渲染 char 节点（它会继承 text 节点的整体变换）
			 (render-node char-node)
			 (loop (cdr children) (+ x (* adv (node-scale char-node)))))
		       ;; 资源未就绪，跳过该字符（不绘制，也不累加偏移，或者用占位符）
		       ;; 简单起见，跳过并继续下一个，但不累加偏移，导致位置错位。
		       ;; 改进：可以累加一个默认宽度（例如 20）或者跳过但不影响后面？这里暂时跳过且不累加。
		       (loop (cdr children) x)))))]
	    [(char)
	     (let ([font (node-resource node)]
		   [ch (node-data node)])
	       (when (and font (> (Texture-id (car font)) 0))
		 (let* ([tex (car font)]
			[glyph-map (cdr font)]
			[cp (char->integer ch)]
			[info (hashtable-ref glyph-map cp #f)])
		   (if info
		       (let* ([src-rect (vector-ref info 0)]
			      [sx (Rectangle-x src-rect)]
			      [sy (Rectangle-y src-rect)]
			      [offset-x (vector-ref info 1)]
			      [offset-y (vector-ref info 2)]
			      [advance-x (vector-ref info 3)]
			      [x (node-x node)]
			      [y (node-y node)]
			      [scale (node-scale node)]
			      [rot (node-rotation node)]
			      [px (node-pivot-x node)]
			      [py (node-pivot-y node)]
			      [src-w (Rectangle-width src-rect)]
			      [src-h (Rectangle-height src-rect)]
			      [dest-w (* src-w scale)]
			      [dest-h (* src-h scale)]
			      [ox (* px dest-w)]
			      [oy (* py dest-h)]
			      [color (node-color node)]
			      [alpha (node-alpha node)]
			      )
			 (BeginShaderMode *sdf-shader*)
			 (draw-texture-pro
			  tex
			  `(,sx ,sy ,src-w ,src-h)
			  `(,(+ x offset-x) ,(+ y offset-y) ,dest-w ,dest-h)
			  `(,ox ,oy) rot
			  (append (list-head color 3)
				  (list (inexact->exact (floor (* alpha (list-ref color 3)))))))
			 (EndShaderMode)
			 )
		       ))
		 ))]
	    [(texture)
	     (let ([tex (node-resource node)])
	       (when (and tex (> (Texture-id tex) 0))
		 (let* ([tex-w (Texture-width tex)]
			[tex-h (Texture-height tex)]
			[x (node-x node)]
			[y (node-y node)]
			[scale (node-scale node)]
			[dest-w (* tex-w scale)]
			[dest-h (* tex-h scale)]
			[px (node-pivot-x node)]
			[py (node-pivot-y node)]
			[ox (* px dest-w)]
			[oy (* py dest-h)]
			[rot (node-rotation node)]
			[color (node-color node)]
			[alpha (node-alpha node)]
			)
		   (draw-texture-pro
		    tex
		    `(0 0 ,tex-w ,tex-h)
		    `(,x ,y ,dest-w ,dest-h)
		    `(,ox ,oy) rot
		    (append (list-head color 3)
			    (list (inexact->exact (floor (* alpha (list-ref color 3))))))))
		 ))])))
      (for-each render-node
		(reverse (node-children node)))
      ))

  (define render
    (lambda (node)
      (render-node node)
      ))
  
  )
