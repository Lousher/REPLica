(library (language transpiler)
  (export read-rpl rpl->library
	  rpl-imports
	  rpl-exports
	  rpl-defines
	  rpl-stages)
  (import (chezscheme))

  (define-record-type rpl
    (fields (mutable imports)
	    (mutable exports)
	    (mutable defines)
	    (mutable stages)))

  (define read-rpl
    (lambda (filename)
      (let ([p (open-input-file filename)])
	(let loop ([import-exp #f]
		   [export-exp #f]
		   [define-exps '()]
		   [stage-exps '()])
	  (let ([x (read p)])
	    (if (eof-object? x)
		(begin
		  (close-input-port p)
		  (make-rpl
		   import-exp export-exp
		   (reverse define-exps)
		   (reverse stage-exps))
		  )
		(case (car x)
		  [(import)
		   (if import-exp
		       (loop import-exp export-exp
			     define-exps stage-exps)
		       (loop (cdr x) export-exp
			     define-exps stage-exps))
		   ]
		  [(export)
		   (if export-exp
		       (loop import-exp export-exp
			     define-exps stage-exps)
		       (loop import-exp (cdr x)
			     define-exps stage-exps))
		   ]
		  [(define)
		   (loop import-exp export-exp
			 (cons (cdr x) define-exps)
			 stage-exps)]
		  [(stage)
		   (loop import-exp export-exp
			 define-exps
			 (cons (cdr x) stage-exps))]
		  [else (error 'read-rpl "Unknow RPL Syntax" (car x))])
		))))))

  (define stage->case
    (lambda (body)
      (let comp ([ops body] [pc 0] [cases '()])
	(if (null? ops)
	    (values (reverse cases) pc)
	    (let ([op (car ops)])
	      (case (car op)
		[(show)
		 (comp (cdr ops) (+ pc 1)
		       (cons
			`[(,pc)
			  (let ([node (make-node ,pc 'texture (ref ,(cadr op)) #f)])
			    (node-add! (state-root game) node))
			  (state-pc-set! game ,(+ pc 1))] cases))]
		[else
		 (error 'stage->case "Unkown Stage Syntax" (car op))])))
	)
      ))

  
  )
