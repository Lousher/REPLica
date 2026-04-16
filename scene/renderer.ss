(library (scene renderer)
  (export render init-renderer uninit-renderer)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (engine event))

  (define *sdf-shader* #f)
  (define *text-x* (make-parameter 0.0))
  (define *text-y* (make-parameter 0.0))
  (define *text-scale* (make-parameter 1.0))
  (define *text-rotation* (make-parameter 0.0))
  (define *text-alpha* (make-parameter 1.0))
  (define *text-color* (make-parameter '(255 255 255 255)))

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

  (define get-char-advance
    (lambda (char-node default-width)
      (let* ([font-obj (node-resource char-node)]
	     [ch (node-data char-node)]
	     [scale (node-scale char-node)])
	(if (and font-obj (pair? font-obj))
	    (let* ([glyph-map (cdr font-obj)]
		   [cp (char->integer ch)]
		   [info (hashtable-ref glyph-map cp #f)])
	      (if info
		  (* (vector-ref info 3) scale)
		  (begin
		    (TraceLog LOG_WARNING (format "Glyph missing:~a" ch))
		    (* scale default-width))))
	    (begin
	      (* scale default-width))))))

  (define (get-char-height char-node default-height)
    (let* ([font-obj (node-resource char-node)]
           [scale (node-scale char-node)]
           [ch (node-data char-node)])
      (if (and font-obj (pair? font-obj))
          (let* ([glyph-map (cdr font-obj)]
		 [cp (char->integer ch)]
		 [info (hashtable-ref glyph-map cp #f)])
            (if info
		(* (Rectangle-height (vector-ref info 0)) scale)
		(* scale default-height)))
          (* scale default-height))))

  (define (get-char-offset-y char-node)
    (let* ([font-obj (node-resource char-node)]
           [scale (node-scale char-node)]
           [ch (node-data char-node)])
      (if (and font-obj (pair? font-obj))
          (let* ([glyph-map (cdr font-obj)]
		 [cp (char->integer ch)]
		 [info (hashtable-ref glyph-map cp #f)])
            (if info
		(* (vector-ref info 2) scale)   ; offset-y 是向量的第三个元素（索引2）
		(* scale 0)))
          0)))

  (define render-node
    (lambda (node)
      (when (node-visible? node)
	(let ([type (node-type node)])
	  (case type
	    [(root)
	     (for-each render-node (node-children node))]
	    [(interact)
	     (let* ([data (node-data node)]
		    [w (car data)]
		    [h (cdr data)]
		    [x (node-x node)]
		    [y (node-y node)]
		    [cbs (node-customize node)]
		    [click (assv 'click cbs)]
		    [hover (assv 'hover cbs)]
		    [leave (assv 'leave cbs)])
	       (register-interact-region
		(node-id node)
		x y w h
		(if click (cdr click) #f)
		(if hover (cdr hover) #f)
		(if leave (cdr leave) #f))
	       (for-each render-node (node-children node)))]
	    [(text)
	     (let* ([children (node-children node)]
		    [custom (node-customize node)]
		    [layout (cdr (assv 'layout custom))]
		    [spacing (cdr (assv 'spacing custom))]
		    [tx (node-x node)]
		    [ty (node-y node)]
		    [tscale (node-scale node)]
		    [trot (node-rotation node)]
		    [tpx (node-pivot-x node)]
		    [tpy (node-pivot-y node)]
		    [tcolor (node-color node)]
		    [talpha (node-alpha node)]
		    [default-advance 20]
		    [default-height 30])
	       (let measure ([nodes children] [x 0.0] [y 0.0] [max-w 0.0] [max-h 0.0] [positions '()])
		 (if (null? nodes)
		     (let* ([total-width max-w]
			    [total-height max-h]
			    [offset-x (case layout
					[(left) 0]
					[(center) (- (/ total-width 2))]
					[(right) (- total-width)])])
		       (let render ([nodes children]
				    [positions (reverse positions)])
			 (unless (null? nodes)
			   (let* ([char-node (car nodes)]
				  [pos (car positions)]
				  [local-x (car pos)]
				  [local-y (cdr pos)]
				  [pivot-x (* tpx total-width)]
				  [pivot-y (* tpy total-height)]
				  [dx (- (+ local-x offset-x) pivot-x)]
				  [dy (- local-y pivot-y)]
				  [rad (* trot (/ (atan 0 -1) 180))]
				  [cos-t (cos rad)]
				  [sin-t (sin rad)]
				  [rotated-x (- (* dx cos-t) (* dy sin-t))]
				  [rotated-y (+ (* dy cos-t) (* dx sin-t))]
				  [world-x (+ tx (* tscale rotated-x))]
				  [world-y (+ ty (* tscale rotated-y))])
			     (parameterize ([*text-x* world-x]
					    [*text-y* world-y]
					    [*text-scale* tscale]
					    [*text-rotation* trot]
					    [*text-alpha* talpha]
					    [*text-color* tcolor])
			       (render-node char-node))
			     (render (cdr nodes) (cdr positions))
			     ))))
		     (let* ([char-node (car nodes)]
			    [adv (get-char-advance char-node default-advance)]
			    [h (get-char-height char-node default-height)]
			    [oy (get-char-offset-y char-node)])
		       (measure (cdr nodes)
				(+ x adv spacing)
				y
				(max max-w (+ x adv))
				(max max-h (+ h (abs oy)))
				(cons (cons x oy) positions))))))]
	    [(char)
	     (let* ([base-x (*text-x*)]
		    [base-y (*text-y*)]
		    [base-scale (*text-scale*)]
		    [base-rot (*text-rotation*)]
		    [base-alpha (*text-alpha*)]
		    [base-color (*text-color*)]
		    [font (node-resource node)]
		    [ch (node-data node)])
	       (when (and font (> (Texture-id (car font)) 0))
		 (let* ([tex (car font)]
			[glyph-map (cdr font)]
			[cp (char->integer ch)]
			[info (hashtable-ref glyph-map cp #f)])
		   (if info
		       (let* ([src-rect (vector-ref info 0)]
			      [offset-x (vector-ref info 1)]
			      [offset-y (vector-ref info 2)]
			      [node-x (node-x node)]
			      [node-y (node-y node)]
			      [node-scale (node-scale node)]
			      [node-rot (node-rotation node)]
			      [node-color (node-color node)]
			      [node-alpha (node-alpha node)]
			      [src-w (Rectangle-width src-rect)]
			      [src-h (Rectangle-height src-rect)]
			      ;; 合并所有局部偏移
			      [local-dx (+ node-x)]
			      [local-dy (+ node-y)]
			      ;; 将局部偏移按照 text 的整体旋转进行旋转
			      [rad (* base-rot (/ (atan 0 -1) 180))]
			      [cos-r (cos rad)]
			      [sin-r (sin rad)]
			      [rot-dx (- (* local-dx cos-r) (* local-dy sin-r))]
			      [rot-dy (+ (* local-dx sin-r) (* local-dy cos-r))]
			      ;; 最终世界坐标 = 基准坐标 + 旋转后的偏移
			      [final-x (+ base-x rot-dx)]
			      [final-y (+ base-y rot-dy)]
			      [dest-w (* src-w node-scale base-scale)]
			      [dest-h (* src-h node-scale base-scale)]
			      [final-rot (+ base-rot node-rot)]
			      ;; 颜色调制：分量相乘再除以255（假设0-255）
			      [final-color (map (lambda (c1 c2) (inexact->exact (floor (/ (* c1 c2) 255))))
						base-color node-color)]
			      [final-alpha (* base-alpha node-alpha)]
			      [tint (append (list-head final-color 3)
					    (list (inexact->exact (floor (* final-alpha (list-ref final-color 3))))))]
			      [px (node-pivot-x node)]
			      [py (node-pivot-y node)]
			      [ox (* px dest-w)]
			      [oy (* py dest-h)])
			 (BeginShaderMode *sdf-shader*)
			 (draw-texture-pro tex
					   `(,(Rectangle-x src-rect) ,(Rectangle-y src-rect) ,src-w ,src-h)
					   `(,final-x ,final-y ,dest-w ,dest-h)
					   `(,ox ,oy)
					   final-rot
					   tint)
			 (EndShaderMode))
		       (TraceLog LOG_WARNING (format "Glyph not found: ~a" ch))))))]
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
		 ))
	     ])))
      ))

  (define render
    (lambda (node)
      (render-node node)
      ))
  
  )
