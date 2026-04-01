(library (render)
  (export draw)
  (import (chezscheme)
          (raylib ffi)
          (raylib constant)
          (state)
          (scene))

  (define (draw game)
    (let* ([root-id (state-root game)]
           [node-table (state-table game)]
           [root (hashtable-ref node-table root-id #f)])
      (define (draw-node node x y)
        (when (node-visible? node)
          (let ([cur-x (+ x (node-x node))]
                [cur-y (+ y (node-y node))])
            (case (node-type node)
              ([image]
               (DrawRectangle
		(inexact->exact cur-x)
		(inexact->exact cur-y)
                100 100 (make-Color 255 0 0 255)))
              ([text]
               (DrawText
		(node-data node)
		(inexact->exact cur-x)
		(inexact->exact cur-y)
                20 (make-Color 255 255 255 255)))
              (else #f))
            (for-each (lambda (child-id)
                        (let ([child (hashtable-ref node-table child-id #f)])
                          (when child (draw-node child cur-x cur-y))))
                      (node-children node)))))
      (draw-node root 0 0))))
