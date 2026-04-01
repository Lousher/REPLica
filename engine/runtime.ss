(library (runtime)
  (export show! text! wait! clear!)
  (import (chezscheme)
          (state)
          (scene))

  (define (show! game id)
    (let* ([node-id (state-next game)]
           [node (make-scene-node node-id 'image id #f)]
           [root-id (state-root game)]
           [node-table (state-table game)])
      (let ([root (hashtable-ref node-table root-id #f)])
        (node-add! root node-id))
      (hashtable-set! node-table node-id node)
      (state-next-set! game (+ node-id 1))))

  (define (text! game str)
    (let* ([node-id (state-next game)]
           [node (make-scene-node node-id 'text #f str)]
           [root-id (state-root game)]
           [node-table (state-table game)])
      (let ([root (hashtable-ref node-table root-id #f)])
        (node-add! root node-id))
      (hashtable-set! node-table node-id node)
      (state-next-set! game (+ node-id 1))
      (state-waiting-set! game 'text)))

  (define (wait! game)
    (state-waiting-set! game 'text))

  (define (clear! game)
    (let ([root-id (state-root game)]
          [node-table (state-table game)])
      (let ((root (hashtable-ref node-table root-id #f)))
        (define (remove-text-nodes node)
          (for-each (lambda (child-id)
                      (let ((child (hashtable-ref node-table child-id #f)))
                        (when child
                          (if (eq? (node-type child) 'text)
                              (node-remove! node child-id)
                              (remove-text-nodes child)))))
                    (node-children node)))
        (remove-text-nodes root)))))
