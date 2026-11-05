(library (game event)
  (export clicked? hovered? point-in-picture?)
  (import (chezscheme)
	  (game type)
	  (game window)
	  (game picture)
	  (game resource)
	  (ffi raylib binding))

  (define HITMAP_WIDTH 256)
  (define HITMAP_HEIGHT 256)
  (define (to-int x) (inexact->exact (round x)))
  (define point-in-rectangle?
    (lambda (p rect)
      (let-values ([(px py) (vector2-values p)]
		   [(rx ry rw rh) (rectangle-values rect)])
	(and (>= px rx) (< px (+ rx rw))
	     (>= py ry) (< py (+ ry rh))))))
  (define picture->hitmap
    (let ([f (make-frame HITMAP_WIDTH HITMAP_HEIGHT)])
      (lambda (pic)
	(for-each loader (picture-deps pic))
	(let ([rt (LoadRenderTextureEx HITMAP_WIDTH HITMAP_HEIGHT PIXELFORMAT_UNCOMPRESSED_R8G8B8A8)])
	  (BeginTextureMode rt)
	  ((picture-drawer pic) f)
	  (EndTextureMode)
	  (let ([img (LoadImageFromTexture (ftype-&ref RenderTexture (texture) rt))])
	    (UnloadRenderTexture rt)
;	    (ImageFormat img PIXELFORMAT_)
	    (let* ([base (ftype-ref Image (data) img)]
		   [alpha (make-bytevector (* HITMAP_WIDTH HITMAP_HEIGHT))]
		   )
	      (do ([i 0 (+ i 1)])
		  ((= i (* HITMAP_WIDTH HITMAP_HEIGHT)))
		(let* ([pixel-addr (+ base (* i 4))]
		       [a-ptr (make-ftype-pointer unsigned-8 (+ pixel-addr 3))])
		  (bytevector-u8-set! alpha i (ftype-ref unsigned-8 () a-ptr))))
	      (UnloadImage img)
	      alpha
	      ))))))
  (define (point-in-hitmap? p hp rect)
    (let-values ([(px py) (vector2-values p)]
		 [(rx ry rw rh) (rectangle-values rect)])
      (if (and (>= px rx) (< px (+ rx rw))
               (>= py ry) (< py (+ ry rh)))
          (let* ([hw HITMAP_WIDTH]
		 [hh HITMAP_HEIGHT]
		 [lx (- px rx)]
		 [tx (min (- hw 1) (inexact->exact (floor (* lx (/ hw rw)))))]
		 [ty (min (- hh 1) (inexact->exact (floor (* (- py ry) (/ hh rh)))))]
		 [idx (+ (* ty hw) tx)]
		 [a (bytevector-u8-ref hp idx)])
	    (TraceLog LOG_ERROR
		      (format "px=~a rx=~a rw=~a tx=~a alpha=~a~n" px rx rw tx a))
            (> a 128))
          #f)))

  (define hitmap-pool (make-eq-hashtable))
  (define point-in-picture?
    (lambda (pic)
      (lambda (p f)
	(let ([dest (frame-dest f)])
	  (let-values ([(x y w h) (rectangle-values dest)])
	    (let* ([w-int (to-int w)]
		   [h-int (to-int h)]
		   [hitmap-key pic]
		   [hitmap (if (hashtable-contains? hitmap-pool hitmap-key)
			       (hashtable-ref hitmap-pool hitmap-key #f)
			       (let ([hp (picture->hitmap pic)])
				 (hashtable-set! hitmap-pool hitmap-key hp)
				 hp))])

	      (let ([res
		     (point-in-hitmap? p hitmap dest)])
		(TraceLog LOG_ERROR (format "[HITMAP] Result is ~a" res))
		res)))))))
  
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
