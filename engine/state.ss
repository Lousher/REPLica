(library (state)
  (export make-game-state
          state-root
          state-root-set!
          state-table
          state-table-set!
          state-next
          state-next-set!
          state-waiting
          state-waiting-set!)
  (import (chezscheme)
          (scene))

  (define-record-type state
    (fields (mutable root)   ; 根节点 ID
            (mutable table)   ; ID -> node
            (mutable next)
            (mutable waiting)))

  (define (make-game-state)
    (let* ([root-id 0]
           [root (make-scene-node root-id 'root #f #f)]
           [node-table (make-hashtable (lambda (x) x) fx=?)])
      (hashtable-set! node-table root-id root)
      (make-state root-id node-table (+ root-id 1) 'none))))
