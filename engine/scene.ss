(library (scene)
  (export make-scene-node
	  node?
	  node-id
	  node-id-set!
	  node-type
	  node-type-set!
	  node-resource
	  node-resource-set!
	  node-data
	  node-data-set!
          node-x node-y
	  node-x-set!
	  node-y-set!
	  node-scale node-scale-set!
	  node-alpha node-alpha-set!
	  node-color node-color-set!
	  node-anchor-x node-anchor-x-set!
	  node-anchor-y node-anchor-y-set!
	  node-origin-x node-origin-x-set!
	  node-origin-y node-origin-y-set!
	  node-visible?
	  node-visible?-set!
	  node-children
          node-children-set!
	  node-add!
	  node-remove!
          node-find)
  (import (chezscheme))

  (define-record-type node
    (fields (mutable id)
            (mutable type)       ; 'root, 'image, 'text
            (mutable resource)
            (mutable data)       ; 文本字符串
            (mutable x) (mutable y)
	    (mutable scale)
	    (mutable rotation)
	    (mutable alpha)
	    (mutable color)
	    (mutable anchor-x)
	    (mutable anchor-y)
	    (mutable origin-x)
	    (mutable origin-y)
            (mutable visible?)
            (mutable children))  ; list of child ids
    (protocol
     (lambda (new)
       (lambda (id type resource data)
         (new id type resource data
	      0 0
	      1 0 1 '(255 255 255 255)
	      0.5 0.5
	      0.5 0.5
	      #t '())))))

  (define (make-scene-node id type resource-id data)
    (make-node id type resource-id data))

  (define (node-add! parent child-id)
    (node-children-set!
     parent
     (cons child-id (node-children parent))))

  (define (node-remove! parent child-id)
    (node-children-set!
     parent
     (filter (lambda (cid) (not (= cid child-id))) (node-children parent))))

  (define (node-child! parent child-id)
    (node-children-set!
     parent
     (filter
      (lambda (cid) (not (= cid child-id)))
      (node-children parent))))

  (define (node-find root-id target-id node-table)
    (letrec ([find-in-node
              (lambda (node)
                (if (= (node-id node) target-id)
                    node
                    (let loop ([children (node-children node)])
                      (if (null? children)
                          #f
                          (let ([child-node (hashtable-ref node-table (car children) #f)])
                            (if child-node
                                (or (find-in-node child-node)
                                    (loop (cdr children)))
                                (loop (cdr children))))))))])
      (find-in-node (hashtable-ref node-table root-id #f)))))
