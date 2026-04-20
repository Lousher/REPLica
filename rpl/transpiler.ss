(library (rpl transpiler)
  (export transpile)
  (import (chezscheme))

  (define reads
    (lambda (p)
      (let loop ([exprs '()])
	(let ([x (read p)])
	  (if (eof-object? x)
	      (reverse exprs)
	      (loop (cons x exprs)))))))

  (define transpile-body
    (lambda (body start-pc)
      (let loop ([ops body] [pc start-pc] [states '()])
	(if (null? ops)
	    (reverse states)
	    (let ([op (car ops)])
	      (case (car op)
		[(show) ;(show xxx)
		 (let ([next-pc (+ pc 1)]
		       [path (cadr op)])
		   (loop (cdr ops) next-pc
			 (cons
			  `[,pc
			    (let ([root (state-root game)]
				  [tex-node (make-texture-node rm (node-id-gen) "t1")])
			      (node-add! root tex-node))
			    (state-pc-set! game ,next-pc)]
			  states)))
		 ]
		[else 'transpile-body "Unsupported operation: " (car op)]
		)))))
    )

  (define transpile-stage
    (lambda (name body)
      (let* ([stages (transpile-body body 0)]
	     [max-pc (if (null? stages) 0
			 (apply max (map car stages)))])
	`(define (,name rm)
	   (lambda (game)
	     (case (state-pc game)
	       ,@(map
		  (lambda (st)
		    `[,(car st) ,@(cdr st)])
		  stages)
					;	     [,max-pc #f]
	       [else #f]))))))

  (define (string-index str ch start)
    (let ([len (string-length str)])
      (let loop ([i start])
        (if (>= i len)
            #f
            (if (char=? (string-ref str i) ch)
                i
                (loop (+ i 1)))))))
  
  (define (string-split str sep)
    (let ([len (string-length str)])
      (let loop ([start 0] [parts '()])
	(let ([pos (string-index str sep start)])
          (if pos
              (loop (+ pos 1) (cons (substring str start pos) parts))
              (reverse (cons (substring str start len) parts)))))))

  (define path->lib-name
    (lambda (path)
      (let ([root (path-root path)])
	(map string->symbol (string-split root (directory-separator)))
	)))
  
  (define transpile
    (lambda (in out)
      (let ([exprs (call-with-input-file in reads)])
	(let ([exports (let ([exp (find (lambda (x) (and (pair? x) (eqv? 'export (car x)))) exprs)])
			 (if exp (cdr exp) '()))]
	      [stages (filter (lambda (x) (and (pair? x) (eqv? 'stage (car x)))) exprs)])
	  (when (null? stages)
	    (error 'transpile "No stage definitions found"))
	  (let ([stage-defs (map (lambda (s) (transpile-stage (cadr s) (cddr s))) stages)]
		[stage-names (map cadr stages)]
		[lib-name (path->lib-name out)])
	    (let ([export-list (if (null? exports) stage-names exports)])
	      (let ([code `(library (,@lib-name)
			     (export ,@export-list)
			     (import (chezscheme)
				     (raylib ffi)
				     (raylib constant)
				     (scene node)
				     (engine resource)
				     (engine state)
				     (engine event)
					;(rpl runtime)
				     )
			     ,@stage-defs)])
		(with-output-to-file out
		  (lambda ()
		    (pretty-print code))
		  'replace))))))))
  )
