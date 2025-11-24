(library (tool)
  (export reads format-green extract-strings alist-update format-red ftype-pointer->ftype-symbol)
  (import (chezscheme))

  (define ftype-pointer->ftype-symbol
    (let* ([prefix "#<ftype-pointer"]
	   [start (string-length prefix)])
      (lambda (fptr)
	(let* ([str (with-output-to-string (lambda () (display fptr)))]
	       [len (string-length str)])
	  (let find ([end (- len 1)])
	    (if (char=? #\space (string-ref str end))
		(string->symbol (substring str (+ start 1) end))
		(find (- end 1))))))))

  (define alist-update
    (lambda (alist key val)
      (cons (cons key val)
	    (filter (lambda (pair) (not (eqv? key (car pair)))) alist))))
  
  (define extract-strings
    (lambda (scripts)
      (cond
       [(null? scripts) '()]
       [(string? scripts) (list scripts)]
       [(atom? scripts) '()]
       [(list? scripts)
	(append (extract-strings (car scripts))
		(extract-strings (cdr scripts)))]
       [else '()])))
  
  (define reads
    (lambda (port)
      (let ([content (read port)])
	(if (eof-object? content)
	    '()
	    (cons content (reads port))))))

  (define format-green
    (lambda (fmt-str . rest)
      (apply format (format "\x1b;[0;32m~a\x1b;[0m" fmt-str) rest)))

  (define format-red
    (lambda (fmt-str . rest)
      (apply format (format "\x1b;[0;31m~a\x1b;[0m" fmt-str) rest)))
  )
