(library (rpl compile)
  (export compile-dsl)
  (import (chezscheme))

  (define compile-dsl
    (lambda (script)
      (let ([insts '()])
	(define walk
	  (lambda (node x y a z)
	    (cond
	     [(null? node) #f]
	     [(eq? (car node) 'at) ; (at x y (...))
	      (walk (cadddr node) (+ x (cadr node)) (+ y (caddr node)) a z)]
	     [(eq? (car node) 'alpha) ;(aplha A (...))
	      (walk (caddr node) x y (* a (cadr node)) z)]
	     [(eq? (car node) 'setz)
              (walk (caddr node) x y a (cadr node))]
	     [(eq? (car node) 'parallel)
              (for-each (lambda (sub) (walk sub x y a z)) (cdr node))]
	     [(eq? (car node) 'show)
              (let ([id (cadr node)])
		(set! insts
                      (append insts
                              `((LOADK 0 ,id)      ; R0 = 图片路径
				(LOADK 1 ,x)       ; R1 = 累计 X
				(LOADK 2 ,y)       ; R2 = 累计 Y
				(SHOW 0 1 2)))))]
	     [(eq? (car node) 'text)
              (let ([id (cadr node)] [content (caddr node)])
		(set! insts
                      (append insts
                              `((LOADK 0 ,id)
				(LOADK 1 ,content)
				(TEXT 0 1)))))]
	     [(eq? (car node) 'wait)
              (set! insts (append insts '((WAIT))))])))
	(for-each (lambda (exp) (walk exp 0.0 0.0 1.0 0)) script)
	insts))))
