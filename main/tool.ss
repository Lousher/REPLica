(library (tool)
  (export reads)
  (import (rnrs))

  (define reads
  (lambda (port)
    (let ([content (read port)])
      (if (eof-object? content)
	  '()
	  (cons content (reads port))))))
  )
