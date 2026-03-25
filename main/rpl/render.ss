(library (rpl render)
  (export init uninit draw)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (rpl scene)
	  (vm main))

  (define init
    (lambda ()
;      (SetConfigFlags FLAG_VSYNC_HINT)
      (InitWindow 1280 720 "REPLica Engine")
      ;(SetTargetFPS 60) 影响异步资源加载速度
      ))

  (define uninit
    (lambda ()
      (CloseWindow)))

  (define draw
    (lambda (vm node parent-x parent-y parent-alpha parent-scale parent-rot)
      (when (scene-node-visible? node)
	(let* ([world-x (+ parent-x (* (scene-node-x node) parent-scale))]
	       [world-y (+ parent-y (* (scene-node-y node) parent-scale))]
	       [world-alpha (* parent-alpha (scene-node-alpha node))]
	       [world-scale (* parent-scale (scene-node-scale-x node))]
	       [world-rot (+ parent-rot (scene-node-rotation node))]
	       [color (scene-node-color node)])
	  (Color-a-set! color (inexact->exact (round (* 255 world-alpha))))
	  (case (scene-node-type node)
	    [(texture)
	     (let ([payload (scene-node-payload node)])
	       (if (symbol? payload)
		   (let* ([assets (state-assets vm)]
			  [mtx (state-asset-mutex vm)]
			  [entry (with-mutex mtx (hashtable-ref assets payload #f))])
		     (when entry
		       (let ([status (vector-ref entry 2)])
			 (case status
			   [(image-ready)
			    (let* ([img (vector-ref entry 3)]
				   [tex (LoadTextureFromImage img)])
			      (SetTextureFilter tex 1)
			      (UnloadImage img)
			      (with-mutex mtx
				(vector-set! entry 2 'texture-ready)
				(vector-set! entry 3 tex)))]
			   [(texture-ready)
			    (scene-node-payload-set! node (vector-ref entry 3))]))))
			 (let* ([tex payload]
				[tw (Texture-width tex)]
				[th (Texture-height tex)]
				[src (scene-node-src node)]
				[dest (scene-node-dest node)]
				[origin (scene-node-origin node)])
			   ;; 按需更新源矩形 (仅初始化一次)
			   (when (zero? (Rectangle-width src))
			     (Rectangle-width-set! src (inexact tw))
			     (Rectangle-height-set! src (inexact th)))
			   ;; 每帧更新目标位置
			   (Rectangle-x-set! dest (inexact world-x))
			   (Rectangle-y-set! dest (inexact world-y))
			   (Rectangle-width-set! dest (* tw world-scale))
			   (Rectangle-height-set! dest (* th world-scale))
			   ;; 渲染
			   (DrawTexturePro tex src dest origin (inexact world-rot) color))))]
	    [(label)
	     (let ([text (scene-node-data node)])
	       (when (string? text)
		 (DrawText text
			   (inexact->exact (round world-x))
			   (inexact->exact (round world-y))
			   30 color)))])
	  (for-each
	   (lambda (child)
	     (draw vm child world-x world-y world-alpha world-scale world-rot))
	   (scene-node-children node))
	  ))))
  )
