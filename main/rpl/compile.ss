(library (rpl compile)
  (export compile-dsl)
  (import (chezscheme))

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
	  (lambda (node x y s r a z) ; x y scale rotation alpha z-index color font
	    (cond
	     [(not (pair? node)) #f]
	     [else
	      (case (car node)
		[(prefab) ;(prefab name (args ...) body)
		 (let ([name (cadr node)] [args (caddr node)] [body (cadddr node)])
		   (hashtable-set! prefab-env name (cons args body)))]
		[(bundle) ; (bundle B_NAME)
		 (emit! `((LOADK 0 ,(cadr node))
					     (BUNDLE 0 0 0)))]
		[(assets) ;(assets (type name . args) (texture bg "a.png") (shader mask #f "b.fs") ...)
		 (for-each (lambda (def)
			     (let ([type (car def)] [id (cadr def)] [paths (cddr def)])
			       (emit! `((LOADK 0 ,type)
					(LOADK 1 ,id)
					(LOADK 2 ,paths)
					(ASSET 0 1 2)))))
			   (cdr node))]
		[(at) ;(at X Y (...))
		 (walk (cadddr node) (+ x (cadr node)) (+ y (caddr node)) s r a z)]
		[(scale) ;(scale S (...))
		 (let* ([s-offset (cadr node)] [new-s (* s s-offset)])
		   (emit! `((LOADK 10 ,new-s) (SETS 10)))
		   (walk (caddr node) x y new-s r a z)
		   (emit! `((LOADK 10 ,s) (SETS 10))))]
		[(rotate) ;; 【显式修复】原版缺少 SETR 的发射
                 (let* ([r-offset (cadr node)]
			[new-r (+ r r-offset)])
                   (emit! `((LOADK 10 ,new-r) (SETR 10)))
                   (walk (caddr node) x y s new-r a z)
                   (emit! `((LOADK 10 ,r) (SETR 10))))]
		[(alpha) ;(alpha A (...))
		 (walk (caddr node) x y s r (* a (cadr node)) z)]
		[(parallel) ;(parallel (...) (...))
		 (for-each (lambda (sub) (walk sub x y s r a z)) (cdr node))]
		[(show) ; (show XXX)
		 (emit!
		  `((LOADK 0 ,(cadr node))
		    (LOADK 1 ,x)
		    (LOADK 2 ,y)
		    (SHOW 0 1 2)))]
		[else ; not a predifined keyword, maybe a prefab macro
		 ;(xxx a b c d ...)
		 (let ([macro (hashtable-ref prefab-env (car node) #f)])
		   (if macro
		       (let* ([args-nams (car macro)]
			      [body (cdr macro)]
			      [bindings (map cons args-nams (cdr node))]
			      [expanded-body (substitute body bindings)])
			 (walk expanded-body x y s r a z))
		       (error 'compile-dsl "Unknow OP" (car node))))
		 ]
		)])))
	(for-each (lambda (exp) (walk exp 0.0 0.0 1.0 0 1.0 0)) script)
	(reverse insts)))))
