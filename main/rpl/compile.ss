(library (rpl compile)
  (export compile-dsl)
  (import (chezscheme))

  ; for calculating X & Y move
  (define DEG->RAD (/ 3.141592653589793 180.0))

  (define compile-dsl
    (lambda (script)
      (let ([insts '()]
	    [prefab-env (make-hashtable symbol-hash symbol=?)])
	(define emit!
	  (lambda (new-insts)
	    (for-each (lambda (i) (set! insts (cons i insts))) new-insts)))
	(define substitute
	  (lambda (tree bindings)
	    (cond
	     [(null? tree) '()]
	     [(symbol? tree) (let ([b (assq tree bindings)]) (if b (cdr b) tree))]
	     [(pair? tree) (cons (substitute (car tree) bindings)
				(substitute (cdr tree) bindings))]
	     [else tree])))
	(define walk
	  (lambda (node x y s r a z c f) ; x y scale rotation alpha z-index color font
	    (cond
	     [(not (pair? node)) #f]
	     [else
	      (case (car node)
		[(prefab) ;(prefab name (args ...) body)
		 (let ([name (cadr node)] [args (caddr node)] [body (cadddr node)])
		   (hashtable-set! prefab-env name (cons args body)))]
		[(bundle) ; (bundle B_NAME)
		 (emit! `((LOADK 0 ,(cadr node)) (BUNDLE 0 0 0)))]
		[(assets) ;(assets (type name . args) (texture bg "a.png") (shader mask #f "b.fs") ...)
		 (for-each (lambda (def)
			     (let ([type (car def)] [id (cadr def)] [paths (cddr def)])
			       (emit! `((LOADK 0 ,type)
					(LOADK 1 ,id)
					(LOADK 2 ,paths)
					(ASSET 0 1 2)))))
			   (cdr node))]
		[(at) 
		 (let* ([dx (cadr node)]
                        [dy (caddr node)]
                        [rad (* r DEG->RAD)]
                        [cos-r (cos rad)]
                        [sin-r (sin rad)]
                        ;; 【核心修复】应用父节点的 Scale 和 Rotation 进行坐标系转换
                        [new-x (+ x (* s (- (* dx cos-r) (* dy sin-r))))]
                        [new-y (+ y (* s (+ (* dx sin-r) (* dy cos-r))))])
		   (emit! `((LOADK 10 ,new-x) (LOADK 11 ,new-y) (SETP 10 11)))
		   (walk (cadddr node) new-x new-y s r a z c f)
		   (emit! `((LOADK 10 ,x) (LOADK 11 ,y) (SETP 10 11))))]
		[(scale) ;(scale S (...))
		 (let* ([s-offset (cadr node)] [new-s (* s s-offset)])
		   (emit! `((LOADK 10 ,new-s) (SETS 10)))
		   (walk (caddr node) x y new-s r a z c f)
		   (emit! `((LOADK 10 ,s) (SETS 10))))]
		[(rotate) ;; 【显式修复】原版缺少 SETR 的发射
                 (let* ([r-offset (cadr node)]
			[new-r (+ r r-offset)])
                   (emit! `((LOADK 10 ,new-r) (SETR 10)))
                   (walk (caddr node) x y s new-r a z c f)
                   (emit! `((LOADK 10 ,r) (SETR 10))))]
		[(alpha) ;(alpha A (...))
		 (let* ([a-offset (cadr node)] [new-a (* a a-offset)])
		   (emit! `((LOADK 10 ,new-a) (SETA 10)))
		   (walk (caddr node) x y s r (* a (cadr node)) z c f)
		   (emit! `((LOADK 10 ,a (SETA 10)))))]
		[(color) ; (color R G B A (...))
                 (let* ([new-c (list (cadr node) (caddr node) (cadddr node) (car (cddddr node)))])
                   (emit! `((LOADK 10 ,new-c) (SETC 10)))
                   (walk (cadr (cddddr node)) x y s r a z new-c f)
                   (emit! `((LOADK 10 ,c) (SETC 10))))]
		[(typeface)
                 (let ([new-f (cadr node)])
                   (emit! `((LOADK 10 ,new-f) (SETF 10)))
                   (walk (caddr node) x y s r a z c new-f)
                   (emit! `((LOADK 10 ,f) (SETF 10))))]
		[(parallel) ;(parallel (...) (...))
		 (for-each (lambda (sub) (walk sub x y s r a z c f)) (cdr node))]
		[(show) ; (show XXX)
		 (emit!
		  `((LOADK 0 ,(cadr node)) (SHOW 0 0 0)))]
		[(label) (emit! `((LOADK 0 ,(cadr node)) (LABEL 0 0 0)))]
		[(play)
                 (emit! `((LOADK 0 ,(cadr node)) (PLAY 0 0 0)))]
		[(interact) ;(interact W H [(click) (...)] [(hover) (...)])
                 (let ([w (cadr node)] [h (caddr node)] [cases (cdddr node)])
                   (emit! `((LOADK 1 ,w) (LOADK 2 ,h) (IN_BEG 0 1 2)))
                   (for-each
                    (lambda (ca)
                      (let* ([cond-list (if (list? (car ca)) (car ca) (list (car ca)))]
                             [ctype (case (car cond-list) [(click) 2] [(hover) 1] [else 0])]
                             [body (cdr ca)])
                        (emit! `((LOADK 1 ,ctype) (IN_CASE 0 1 0)))
                        (for-each (lambda (b) (walk b x y s r a z c f)) body)
                        (emit! `((GRP_END 0 0 0)))))
                    cases)
                   (emit! `((IN_END 0 0 0))))]
		[else ; not a predifined keyword, maybe a prefab macro
		 ;(xxx a b c d ...)
		 (let ([macro (hashtable-ref prefab-env (car node) #f)])
		   (if macro
		       (let* ([args-nams (car macro)]
			      [body (cdr macro)]
			      [bindings (map cons args-nams (cdr node))]
			      [expanded-body (substitute body bindings)])
			 (walk expanded-body x y s r a z c f))
		       (error 'compile-dsl "Unknow OP" (car node))))
		 ]
		)])))
	(for-each (lambda (exp) (walk exp 0.0 0.0 1.0 0 1.0 0 '(255 255 255 255) #f)) script)
	(reverse insts)))))
