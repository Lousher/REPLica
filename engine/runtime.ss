(library (runtime)
  (export show! text! wait! clear!)
  (import (chezscheme)
          (state)
          (scene))

  (define push-transform!
    (lambda (game)
      (let ([stack (state-transform-stack game)])
	(state-transform-stack-set!
	 game
	 (cons (vector-copy (car stack))
	       stack)))))

  (define pop-transform!
    (lambda (game)
      (let ([stack (state-transform-stack game)])
	(when (not (null? (cdr stack)))
	  (state-transform-stack-set! game (cdr stack))))))

  (define apply-transform!
    (lambda (game kind . args)
      (let ([current (car (state-transform-stack game))])
	(case kind
	  [(at)
	   (vector-set! current 0 (car args))
	   (vector-set! current 1 (cadr args))]
	  [(scale)
	   (vector-set! current 2 (car args))]
	  [(rotate)
	   [vector-set! current 3 (car args)]]
	  [(alpha)
	   (vector-set! current 4 (car args))]
	  [(color)
	   (vector-set! current 5 (car args))]
	  [(anchor)
	   (vector-set! current 6 (car args))
	   (vector-set! current 7 (cadr args))]
	  [(origin)
	   (vector-set! current 8 (car args))
	   (vector-set! current 9 (cadr args))]
	  [else
	   (error 'apply-transform! "Unknow Transform Kind" kind)])))) 
  
  (define (show! game id)
    (let* ([node-id (state-next game)]
	   [tf (car (state-transform-stack game))]
           [node (make-scene-node node-id 'texture id #f)])
      (node-x-set! node (vector-ref tf 0))
      (node-y-set! node (vector-ref tf 1))
      (node-scale-set! node (vector-ref tf 2))
      (node-rotation-set! node (vector-ref tf 3))
      (node-alpha-set! node (vector-ref tf 4))
      (node-color-set! node (vector-ref tf 5))
      (node-anchor-x-set! node (vector-ref tf 6))
      (node-anchor-y-set! node (vector-ref tf 7))
      (node-origin-x-set! node (vector-ref tf 8))
      (node-origin-y-set! node (vector-ref tf 9))
      (let ([root-id (state-root game)]
	    [node-table (state-table game)])
	(let ([root (hashtable-ref node-table root-id #f)])
          (node-add! root node-id))
	(hashtable-set! node-table node-id node)
	(state-next-set! game (+ node-id 1)))))

  )
