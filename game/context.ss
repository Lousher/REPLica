(library (game context)
  (export
   ;; key 常量
    MOMENT FRAME MOUSE CHANNEL
   ;; context 环境
   context? make-empty-context 
   context-with context-let context-ref context-update
   context-ref-or context-has? context-fetch context-fetch-or
   context-env context-values project
   ;; time 维度
   moment? make-moment moment-uptime moment-dt moment-tick
   moment-zero moment-advance
   ;; frame 维度
   frame? make-frame
   frame-dest frame-origin frame-rotation frame-tint
   frame-change-dest frame-change-tint
   frame-change-origin frame-change-rotation
   ;; mouse 维度
   mouse? make-mouse mouse-position mouse-offset mouse-wheel
   mouse-translate
   ;; channel 维度
   channel? make-channel channel-volume channel-pan channel-pitch)
  (import (chezscheme)
          (only (game type) make-vector2 make-rectangle
		vector2-x vector2-y)
	  (only (game color) white))

  ;; ---------- key 常量（避免手写 symbol 拼错） ----------
  (define MOMENT  'moment)
  (define FRAME   'frame)
  (define MOUSE   'mouse)
  (define CHANNEL 'channel)

  ;; ---------- context：开放环境（alist，前缀覆盖） ----------
  (define-record-type context
    (fields env))

  (define (make-empty-context) (make-context '()))

  (define (_context-with ctx k v)
    (make-context (cons (cons k v) (context-env ctx))))

  (define-syntax context-with
    (syntax-rules ()
      [(_ ctx) ctx]
      [(_ ctx [k v] rest ...)
       (context-with
	(_context-with ctx k v)
	rest ...)]))

  (define-syntax context-let
    (syntax-rules ()
      [(_ ctx () body ...)
       (let ([ctx ctx]) body ...)]
      [(_ ctx ([k v] rest ...) body ...)
       (let ([ctx (context-with k v)])
	 (context-let ctx (rest ...) body ...))]))

  ;; 强制存在，缺 key 报错
  (define-syntax context-fetch
    (syntax-rules ()
      [(_ ctx ([var key] ...) body ...)
       (let ([var (context-ref ctx key)] ...)
	 body ...)]))

  ;; 带默认值
  (define-syntax context-fetch-or
    (syntax-rules ()
      [(_ ctx ([var key default] ...) body ...)
       (let ([var (context-ref-or ctx key default)] ...)
	 body ...)]))
  
  (define (context-update ctx k fn)
    (define (replace env)
      (cond [(null? env)
             (error 'context-update "missing key" k (map car (context-env ctx)))]
            [(eq? (caar env) k)
             (cons (cons k (fn (cdar env))) (cdr env))]
            [else
             (cons (car env) (replace (cdr env)))]))
    (make-context (replace (context-env ctx))))

  (define (context-ref ctx k)
    (let ([p (assq k (context-env ctx))])
      (if p
          (cdr p)
          (error 'context-ref "missing context key" k
                 (map car (context-env ctx))))))

  (define (context-ref-or ctx k default)
    (let ([p (assq k (context-env ctx))])
      (if p (cdr p) default)))

  (define (context-has? ctx k)
    (and (assq k (context-env ctx)) #t))

  (define (context-values ctx)
    (map cdr (context-env ctx)))

  ;; 投影器：给 effect 的 accept? 用。返回 (key . value) 或 #f。
  ;; 遍历顺序 = 前缀优先，shadowing 时取最新的。
  (define (project pred)
    (lambda (ctx)
      (let loop ([vs (context-env ctx)])
        (cond [(null? vs) #f]
              [(pred (cdar vs)) (car vs)]
              [else (loop (cdr vs))]))))

  ;; ---------- time ----------
  (define-record-type moment
    (fields uptime dt tick))

  (define (moment-zero) (make-moment 0.0 0.0 0))

  (define (moment-advance t dt)
    (make-moment (+ (moment-uptime t) dt)
		 dt
		 (+ (moment-tick t) 1)))

  ;; ---------- frame ----------
  ;; 注意：这里只提供 4 参数构造 (dest origin rotation tint)。
  ;; 原 world.ss 的 (make-frame w h) 便捷构造用了 white，
  ;; 放到 world.ss / engine.ss 用 (make-frame ... 0 white) 包装。

  (define-record-type frame
    (fields dest origin rotation tint)
    (protocol
     (lambda (new)
       (case-lambda
	 [(d o r t) (new d o r t)]
	 [(w h)
	  (new (make-rectangle 0.0 0.0 (inexact w) (inexact h))
	       (make-vector2 0.0 0.0)
	       0 white)]))))
  
  (define (frame-change-dest f d)
    (make-frame d (frame-origin f) (frame-rotation f) (frame-tint f)))

  (define (frame-change-tint f t)
    (make-frame (frame-dest f) (frame-origin f) (frame-rotation f) t))

  (define (frame-change-origin f o)
    (make-frame (frame-dest f) o (frame-rotation f) (frame-tint f)))

  (define (frame-change-rotation f r)
    (make-frame (frame-dest f) (frame-origin f) r (frame-tint f)))

  ;; ---------- mouse ----------
  (define-record-type mouse
    (fields position offset wheel))

  ;; place 变换 frame 时同步平移 mouse，保证 hovered? 在嵌套作用域同系
  (define (mouse-translate m dx dy)
    (let ([p (mouse-position m)])
      (make-mouse (make-vector2 (+ (vector2-x p) dx)
                                (+ (vector2-y p) dy))
                  (mouse-offset m)
                  (mouse-wheel m))))

  ;; ---------- channel ----------
  (define-record-type channel
    (fields volume pan pitch)
    (protocol
     (lambda (new)
       (case-lambda
         [() (new 1.0 0.0 1.0)]
         [(v pa pi) (new v pa pi)]))))
  )
