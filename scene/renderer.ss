(library (scene renderer)
  (export render)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node))

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
  
  (define draw-node
    (lambda (node)
      (when (node-visible? node)
	(let ([type (node-type node)])
	  (case type
	    [(texture)
	     (let ([tex (node-resource node)]
		   [x (node-x node)]
		   [y (node-y node)]
		   [scale (node-scale node)]
		   [rotation (node-rotation node)]
		   [pivot-x (node-pivot-x node)]
		   [pivot-y (node-pivot-y node)]
		   [color (node-color node)]
		   [alpha (node-alpha node)])
	       (if tex
		   (let* ([tint (append (list-head color 3)
					(list (inexact->exact (round (* alpha (cadddr color))))))]
			  [w (Texture-width tex)]
			  [h (Texture-height tex)]
			  [dest-w (* w scale)]
			  [dest-h (* h scale)]
			  [dest-x x]
			  [dest-y y]
			  [source `(0 0 ,w ,h)]
			  [dest `(,dest-x ,dest-y ,dest-w ,dest-h)]
			  [origin `(,(* pivot-x dest-w) ,(* pivot-y dest-h))])
		     (draw-texture-pro tex source dest origin rotation tint))
		   (TraceLog LOG_ERROR "Not Valid texture"))
	       )])))))

  (define render-node
    (lambda (node)
      (draw-node node)
      (for-each render-node (reverse (node-children node)))))

  (define render
    (lambda (root)
      (for-each render-node
		(reverse (node-children root)))
      ))
  )
