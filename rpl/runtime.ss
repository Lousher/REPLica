(library (rpl runtime)
  (export *current-manager* node-id-gen)
  (import (chezscheme))

  (define *current-manager* (make-parameter #f))
  (define *next-node-id* 0)

  (define node-id-gen
    (lambda ()
      (let ([id *next-node-id*])
	(set! *next-node-id* (+ id 1))
	id))))
