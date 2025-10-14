(define reads
  (lambda (port)
    (let ([content (read port)])
      (if (eof-object? content) '()
	  (cons content (reads port))))))

(define file-suffix
  (lambda (name)
    (let ([len (string-length name)])
      (let col ([i (- len 1)] [res '()])
	(let ([ch (string-ref name i)])
	  (if (char=? #\. ch)
	      (list->string res)
	      (col (- i 1) (cons ch res))))))))

(define :id? (lambda (id) (and (symbol? id) (char=? #\: (string-ref (symbol->string id) 0)))))
(define parse-params
  (lambda (params)
    (fold-left
     (lambda (acc next)
       (if (:id? next)
	   (append acc (list (list next)))
	   (let ([last (last-pair acc)])
	     (set-cdr! (car last) (append (cdar last) (list next)))
	     acc)))
     '()
     params)))

					; --- divider --- ;

(define symbol-format
  (lambda (fmt-str . rest)
    (let* ([strs (map symbol->string rest)]
	   [outcome (apply format fmt-str strs)])
      (string->symbol outcome))))

(define symbols->symbol
  (lambda syms
    (let ([strs (map symbol->string syms)])
      (string->symbol
       (fold-left
	(lambda (acc next)
	  (string-append acc "-" next))
	(car strs)
	(cdr strs))))))
