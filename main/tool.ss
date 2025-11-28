(library (tool)
  (export format-green format-red alist-update alist-put)
  (import (chezscheme))

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
)
