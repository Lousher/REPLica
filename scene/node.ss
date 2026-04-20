(library (scene node)
  (export make-node
          node? 
          node-id node-id-set!
          node-type node-type-set!
          node-resource node-resource-set!
          node-data node-data-set!
          node-x node-x-set!
          node-y node-y-set!
          node-scale node-scale-set!
	  node-rotation node-rotation-set!
          node-alpha node-alpha-set!
          node-color node-color-set!
          node-pivot-x node-pivot-x-set!
          node-pivot-y node-pivot-y-set!
          node-visible? node-visible?-set!
          node-children node-children-set!
          node-tag node-tag-set!
          node-customize node-customize-set!
          node-add!
          node-remove!
          node-find-by-id
          node-find-by-tag
          make-root-node
	  node-clear!
	  )
  (import (chezscheme))

  ;; 节点记录定义
  (define-record-type node
    (fields (mutable id)		; 唯一标识符（整数）
            (mutable type) ; 类型符号: 'root, 'image, 'text, 'button, etc.
            (mutable resource) ; 资源标识：纹理名、字体名、文本字符串等
            (mutable data) ; 附加数据：如文本内容、字体大小、按钮回调等
            (mutable x)	   ; 局部位置 X
            (mutable y)	   ; 局部位置 Y
            (mutable scale)		; 局部缩放（默认 1.0）
            (mutable rotation)		; 局部旋转角度（度，默认 0）
            (mutable alpha)		; 局部透明度（0-1，默认 1）
            (mutable color) ; 局部颜色调乘 (r g b a) 列表，默认 '(255 255 255 255)
	    (mutable pivot-x)
	    (mutable pivot-y)
            (mutable visible?)	  ; 是否可见（默认 #t）
            (mutable children)	  ; 子节点列表（节点对象列表）
            (mutable tag)	  ; 标签符号，用于快速查找
            (mutable customize))  ; 用户自定义数据（任意 Scheme 对象）
    (protocol
     (lambda (new)
       (lambda (id type resource data)
         (new id type resource data
	      0.0 0.0
	      1.0			; scale
	      0				; rotation
              1				; alpha
	      '(255 255 255 255)        ; color
              0.0 0.0			; pivot
              #t			; visible?
              '()			; children
              #f			; tag
              #f)))))             ; customize

  ;; 子节点管理
  (define (node-add! parent child)
    (node-children-set!
     parent (append (node-children parent) (list child))))

  (define (node-remove! parent child)
    (node-children-set!
     parent
     (filter
      (lambda (c) (not (eq? c child)))
      (node-children parent))))

  (define node-clear!
    (lambda (r)
      (node-children-set! r '())))

  ;; 通过 ID 查找节点（深度优先）
  (define (node-find-by-id root id)
    (letrec ([find (lambda (node)
                     (if (= (node-id node) id)
                         node
                         (let loop ((children (node-children node)))
                           (if (null? children)
                               #f
                               (or (find (car children))
                                   (loop (cdr children)))))))])
      (find root)))

  ;; 通过标签查找节点（深度优先，返回第一个匹配）
  (define (node-find-by-tag root tag)
    (letrec ([find (lambda (node)
                     (if (and (node-tag node) (eq? (node-tag node) tag))
                         node
                         (let loop ((children (node-children node)))
                           (if (null? children)
                               #f
                               (or (find (car children))
                                   (loop (cdr children)))))))])
      (find root)))

  ;; 创建根节点（设计分辨率或窗口尺寸）
  (define (make-root-node width height)
    (let ((root (make-node -1 'root #f #f)))
      ;; 根节点不渲染，但存储尺寸到 customize 中（可选）
      (node-customize-set! root (cons width height))
      root)
    )

  )
