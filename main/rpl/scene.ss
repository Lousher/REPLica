(library (rpl scene)
  (export
   scene-node? make-scene-node
   scene-node-id scene-node-type scene-node-z-index scene-node-payload
   scene-node-data scene-node-data-set!
   scene-node-x scene-node-x-set!
   scene-node-y scene-node-y-set!
   scene-node-scale-x scene-node-scale-x-set!
   scene-node-scale-y scene-node-scale-y-set!
   scene-node-rotation scene-node-rotation-set!
   scene-node-alpha scene-node-alpha-set!
   scene-node-color scene-node-color-set!
   scene-node-visible? scene-node-visible?-set!
   scene-node-parent scene-node-parent-set!
   scene-node-children scene-node-children-set!
   
   make-node-root make-node node-add-child!
   node-remove-child! find-node tree-sort-children!
   clear-tree!
	  )
  (import (chezscheme))

  (define-record-type scene-node
    (fields
     ; basic 4 fields
     (mutable id) (mutable type) (mutable z-index) (mutable payload)
     ; additional
     (mutable data) (mutable x) (mutable y) (mutable scale-x) (mutable scale-y)
     (mutable rotation)
     (mutable alpha)
     (mutable color)
     (mutable visible?)
     (mutable parent)
     (mutable children)
     ))

  (define make-node-root
    (lambda ()
      (make-node 'ROOT 'root 0 #f)))

  (define make-node
    (lambda (id type z-index payload)
      (make-scene-node
       id type z-index payload
       #f 0.0 0.0 1.0 1.0 0.0
       1.0 '(255 255 255) #t 
       #f '()))) ; parent childern

  (define tree-sort-children!
    (lambda (node)
      ; sort children node by z-index
      (scene-node-children-set! 
       node
       (list-sort
	(lambda (a b) (< (scene-node-z-index a) (scene-node-z-index b)))
        (scene-node-children node)))))

  (define node-add-child!
    (lambda (parent child)
      (scene-node-parent-set! child parent)
      (scene-node-children-set! parent (cons child (scene-node-children parent)))
      (tree-sort-children! parent)
      ))

  (define node-remove-child!
    (lambda (parent target-id)
      (scene-node-children-set! 
       parent 
       (filter
	(lambda (child) 
	  (if (eqv? (scene-node-id child) target-id)
              (begin (scene-node-parent-set! child #f) #f) ; 解除父引用并剔除
              #t))
        (scene-node-children parent)))))

  (define find-node
    (lambda (root target-id)
      (if (eqv? (scene-node-id root) target-id)
          root
          (let loop ([kids (scene-node-children root)])
            (if (null? kids)
		#f
		(or (find-node (car kids) target-id)
                    (loop (cdr kids))))))))

  (define clear-tree!
    (lambda (node)
      (for-each
       (lambda (child) (scene-node-parent-set! child #f)) (scene-node-children node))
      (scene-node-children-set! node '())))
  )
