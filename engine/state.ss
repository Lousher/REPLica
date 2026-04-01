(library (state)
  (export make-game-state
          state-root
          state-root-set!
          state-table
          state-table-set!
          state-next
          state-next-set!
          state-waiting
          state-waiting-set!
	  state-transform-stack
	  state-transform-stack-set!)
  (import (chezscheme)
          (scene))

  (define-record-type state
    (fields (mutable root)   ; 根节点 ID
            (mutable table)   ; ID -> node
            (mutable next)
            (mutable waiting)
	    (mutable transform-stack)))

  (define (make-game-state)
    (let* ([root-id 0]
           [root (make-scene-node root-id 'root #f #f)]
           [node-table (make-hashtable (lambda (x) x) fx=?)]
					;(x y scale rotation alpha color a-x a y o-x o-y
	   [init-transform (vector 0 0 1 0 1 '(255 255 255 255) 0.5 0.5 0.5 0.5)])
      (hashtable-set! node-table root-id root)
      (make-state root-id node-table (+ root-id 1) 'none (list init-transform)))))
