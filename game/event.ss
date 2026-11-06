(library (game event)
  (export clicked? hovered?
	  inside-animator?)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (game color)
	  (game picture)
	  (ffi raylib binding))

  (define point-in-rectangle?
    (lambda (p rect)
      (let-values ([(px py) (vector2-values p)]
		   [(rx ry rw rh) (rectangle-values rect)])
	(and (>= px rx) (< px (+ rx rw))
		(>= py ry) (< py (+ ry rh))))))

  #| event 是一个输入 条件，与起始状态，满足条件后会改变输出状态的函数 |#
  (define hovered?
    (lambda (win)
      (let* ([mouse-pos (mouse-position (window-mouse win))]
	     [f (window-frame win)]
	     [dest (frame-dest f)])
	(point-in-rectangle? mouse-pos dest))))
    
  (define clicked?
    (lambda (key)
      (lambda (win)
	(let* ([mouse-pos (mouse-position (window-mouse win))]
	       [f (window-frame win)]
	       [dest (frame-dest f)])
	  (and (hovered? win)
	       (IsMouseButtonPressed key))))))

  (define inside-animator?
    (lambda (visual-track)
      (lambda (win)
	(let ([pic (visual-track (window-timeline win))])
	  (if pic
	      (let ([mouse-pos (mouse-position (window-mouse win))]
		    [frame (window-frame win)])
		(hit-test-pixel? mouse-pos frame pic)))))))

  (define hit-rt #f)
  (define PIXEL-BUF (ftype-alloc Color))
   (define alpha-lut
    (let ([lut (make-flvector 256)])
      (do ([i 0 (+ i 1)])
	  ((= i 256))
	(flvector-set! lut i (min 1.0 (sqrt (/ i 255.0)))))
      lut))
   
   (define hit-test-pixel?
     (lambda (pos f pic)
       (unless hit-rt (set! hit-rt (LoadRenderTexture 1 1)))
       (let-values ([(px py) (vector2-values pos)]
		    [(rx ry rw rh) (rectangle-values (frame-dest f))])
	 (if (or (< px rx) (>= px (+ rx rw))
		 (< py ry) (>= py (+ ry rh)))
	     #f
	     (begin
	       (let ([shifted-frame
		      (frame-change-dest f (make-rectangle (- rx px) (- ry py) rw rh))])
		 (BeginTextureMode hit-rt)
		 (ClearBackground (Color<=color blank PIXEL-BUF))
		 ((picture-drawer pic) shifted-frame)
		 (EndTextureMode)
		 (let* ([img (LoadImageFromTexture
			      (ftype-&ref RenderTexture (texture) hit-rt))])
		   (ImageFormat img PIXELFORMAT_UNCOMPRESSED_R8G8B8A8)
		   (let* ([base (ftype-ref Image (data) img)]
			  [a-addr (+ base 3)] 
			  [raw-a (ftype-ref unsigned-8 ()
					    (make-ftype-pointer unsigned-8 a-addr))]
			  [fixed-a (flvector-ref alpha-lut raw-a)])
		     (UnloadImage img)
		     (> fixed-a 0.5))))))))) 
   )
