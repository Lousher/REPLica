(library (tool)
  (export format-green format-red alist-update alist-put alist-ref ftype-pointer->ftype-symbol)
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
  
  (define format-green
    (lambda (fmt-str . rest)
      (apply format (format "\x1b;[0;32m~a\x1b;[0m" fmt-str) rest)))

  (define format-red
    (lambda (fmt-str . rest)
      (apply format (format "\x1b;[0;31m~a\x1b;[0m" fmt-str) rest)))

  (define alist-update
    (lambda (alist key updater)
      (let-values ([(alist-eqv alist-not-eqv) (partition (lambda (p) (eqv? (car p) key)) alist)])
	(append
	 (map (lambda (p) (cons (car p) (updater (cdr p)))) alist-eqv)
	 alist-not-eqv))))
  
  (define alist-put
    (lambda (alist key new)
      (alist-update alist key (lambda (old) new))))

  (define alist-ref
    (lambda (alist keys)
      (fold-left
       (lambda (v key)
	 (cdr (assv key v)))
       alist
       keys)))
)
