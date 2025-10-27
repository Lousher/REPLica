(define script? (lambda (s) (and (list? s)
				 (or (wait-script? s)
				     (normal-script? s)))))
(define wait-script?
  (lambda (script)
    (memv (car script) '(wait))))
(define normal-script?
  (lambda (script)
    (memv (car script) '(scene music text character voice sound camera effect transition))))
(define read-script
  (lambda (port)
    (let ([content (read port)])
      (cond
       [(eof-object? content) '()]
       [(wait-script? content) (list content)]
;       [(next-script? content) (list content)]
       [(normal-script? content) (cons content (read-script port))]
       [else (error 'read-script "Not a valid script" content)]))))
(define read-directives
  (lambda (port)
    (let col ([scripts '()] [script (read-script port)])
      (if (null? script) (reverse scripts)
	  (col (cons script scripts) (read-script port))))))
(define reads
  (lambda (port)
    (let ([content (read port)])
      (if (eof-object? content)
	  '()
	  (cons content (reads port))))))
