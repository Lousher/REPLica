(library (game event)
  (export clicked? hovered? point-in-picture?)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (game picture)
	  (game color)
	  (game resource)
	  (ffi raylib binding))

  (define HITMAP_WIDTH 256)
  (define HITMAP_HEIGHT 256)
  (define (to-int x) (inexact->exact (round x)))
  (define alpha-lut
    (let ([lut (make-flvector 256)])
      (do ([i 0 (+ i 1)])
	  ((= i 256))
	(flvector-set! lut i
		       (min 1.0 (sqrt (/ i 255.0)))))
      lut))
  (define point-in-rectangle?
       (lambda (p rect)
	 (let-values ([(px py) (vector2-values p)]
		      [(rx ry rw rh) (rectangle-values rect)])
	   (and (>= px rx) (< px (+ rx rw))
		(>= py ry) (< py (+ ry rh))))))
  (define picture->hitmap
    (let ([f (make-frame HITMAP_WIDTH HITMAP_HEIGHT)]
	  [C (ftype-alloc Color)])
      (lambda (pic)
	(for-each loader (picture-deps pic))
	(let ([rt (LoadRenderTexture HITMAP_WIDTH HITMAP_HEIGHT)])
	  (BeginTextureMode rt)
	  (ClearBackground (Color<=color blank C))
	  ((picture-drawer pic) f)
	  (EndTextureMode)
	  (let ([img (LoadImageFromTexture (ftype-&ref RenderTexture (texture) rt))])
	    (ImageFormat img PIXELFORMAT_UNCOMPRESSED_R8G8B8A8)
	    (ImageFlipVertical img)
	    (UnloadRenderTexture rt)
	    (let* ([base (ftype-ref Image (data) img)]
		   [alpha (make-flvector (* HITMAP_WIDTH HITMAP_HEIGHT))])
	      (do ([i 0 (+ i 1)])
		  ((= i (* HITMAP_WIDTH HITMAP_HEIGHT)))
		(let* ([pixel-addr (+ base (* i 4))]
		       [a-ptr (make-ftype-pointer unsigned-8 (+ pixel-addr 3))]
		       [raw (ftype-ref unsigned-8 () a-ptr)]
		       [fixed-alpha (flvector-ref alpha-lut raw)])
		  (flvector-set! alpha i fixed-alpha)))
	      (UnloadImage img)
	      alpha
	      ))))))

  (define hitmap-pool (make-eq-hashtable))
  (define point-in-picture?
    (lambda (pic)
      (lambda (p)
	(let* ([hitmap-key pic]
	       [hitmap (if (hashtable-contains? hitmap-pool hitmap-key)
			   (hashtable-ref hitmap-pool hitmap-key #f)
			   (let ([hp (picture->hitmap pic)])
			     (hashtable-set! hitmap-pool hitmap-key hp)
			     hp))])
	  (let-values ([(px py) (vector2-values p)])
	    (if (and (>= px 0) (< px 1.0)
		     (>= py 0) (< py 1.0))
		(let* ([hw HITMAP_WIDTH]
                       [hh HITMAP_HEIGHT]
                       ;; 映射到具体的像素索引
                       [tx (min (- hw 1) (inexact->exact (floor (* px hw))))]
                       [ty (min (- hh 1) (inexact->exact (floor (* py hh))))]
                       [idx (+ (* ty hw) tx)]
                       [a (flvector-ref hitmap idx)])
		  ;; 4. 阈值判定（用你已经 LUT 处理过的 alpha 值）
		  (> a 0.1))
		#f)))))) ; releative

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

  )
