(library (rpl render)
  (export cache-ref cache-ref init uninit draw)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (rpl scene))

  (define *cache* (make-hashtable string-hash string=?))

  (define cache-ref
    (lambda (path)
      (let ([cached (hashtable-ref *cache* path #f)])
	(if cached cached
	    (let ([tex (LoadTexture path)])
	      (hashtable-set! *cache* path tex)
	      tex)))))

  (define init
    (lambda ()
      (InitWindow 1280 720 "REPLica Engine")
      (SetTargetFPS 60)))

  (define uninit
    (lambda ()
      (CloseWindow)))

  (define draw
    (lambda (node parent-x parent-y parent-alpha)
      (when (scene-node-visible? node)
	(let* ([world-x (+ parent-x (scene-node-x node))]
	       [world-y (+ parent-y (scene-node-y node))]
	       [world-alpha (* parent-alpha (scene-node-alpha node))]
	       [color-lst (scene-node-color node)]
	       [tint (make-Color (car color-lst) (cadr color-lst) (caddr color-lst)
				 (inexact->exact (round (* 255 world-alpha))))])
	  (case (scene-node-type node)
	    [(texture)
	     (let* ([payload-id (scene-node-payload node)]
		    [tex-path (if (symbol? payload-id) (symbol->string payload-id) payload-id)]
		    [tex (cache-ref tex-path)])
	       (DrawTextureV tex (make-vector2 world-x world-y) tint))]
	    [(label)
	     (let ([text (scene-node-data node)])
	       (when (string? text)
		 (DrawText text
			   (inexact->exact (round world-x))
			   (inexact->exact (round world-y))
			   30 tint)))])
	  (for-each
	   (lambda (child)
	     (draw child world-x world-y world-alpha))
	   (scene-node-children node))
	  ))))
  )
