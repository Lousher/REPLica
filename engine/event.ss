(library (engine event)
  (export register-interact-region
	  clear-interact-regions!
	  events-update!)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant))

  (define-record-type region
    (fields (mutable id)
	    (mutable x) (mutable y)
	    (mutable w) (mutable h)
	    (mutable click)
	    (mutable hover)
	    (mutable leave)))

  (define *regions* '())
  (define *current-hover* #f)
  (define *node-leave-map* (make-hashtable (lambda (x) x) eqv?))
  (define *last-left-button* #f)

  (define (register-interact-region node-id x y w h click-cb hover-cb leave-cb)
    (set! *regions* (cons (make-region node-id x y w h click-cb hover-cb leave-cb) *regions*))
    (when leave-cb
      (hashtable-set! *node-leave-map* node-id leave-cb)))

  (define clear-interact-regions!
    (lambda ()
      (set! *regions* '())))

  (define (events-update!)
    ;; 鼠标点击
    (let ([current (IsMouseButtonPressed MOUSE_BUTTON_LEFT)])
      (when (and current (not *last-left-button*))
	(let* ([pos (GetMousePosition)]
               [mx (Vector2-x pos)]
               [my (Vector2-y pos)])
          (for-each
           (lambda (r)
             (when (and (>= mx (region-x r)) (<= mx (+ (region-x r) (region-w r)))
			(>= my (region-y r)) (<= my (+ (region-y r) (region-h r))))
               (let ([click-cb (region-click r)])
		 (when click-cb (click-cb)))))
           *regions*)))
      (set! *last-left-button* current))
    ;; 鼠标悬停
    (let* ([pos (GetMousePosition)]
           [mx (Vector2-x pos)]
           [my (Vector2-y pos)]
           [new-id #f]
           [new-region #f])
      ;; 查找当前鼠标下的区域 node-id
      (for-each
       (lambda (r)
         (when (and (>= mx (region-x r)) (<= mx (+ (region-x r) (region-w r)))
                    (>= my (region-y r)) (<= my (+ (region-y r) (region-h r))))
           (set! new-id (region-id r))
           (set! new-region r)))
       *regions*)
      ;; 离开旧区域
      (when (and *current-hover* (not (eqv? new-id *current-hover*)))
        (let ((leave-cb (hashtable-ref *node-leave-map* *current-hover* #f)))
          (when leave-cb (leave-cb))))

      ;; 进入新区域
      (when (and new-id (not (eqv? new-id *current-hover*)))
        (let ((hover-cb (region-hover new-region)))
          (when hover-cb (hover-cb))))

      (set! *current-hover* new-id)))
  )
