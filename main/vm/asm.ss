(library (vm asm)
  (export assemble asm)
  (import (vm main)
	  (vm isa))

  (define assemble
    (lambda (scripts)
      (let* ([labels (make-hashtable string-hash string=?)]
	     [filtered-scripts '()]
	     [inst-count 0])
	; Collect Label and filter persudo cmd
	(for-each
	 (lambda (line)
	   (if (eq? (car line) 'LABEL)
	       (hashtable-set! labels (cadr line) inst-count)
	       (begin
		 (set! filtered-scripts (append filtered-scripts (list line)))
		 (set! inst-count (+ inst-count 1)))))
	 scripts)
	; Generate Code?
	(let ([bv (make-bytevector (* inst-count 4))])
	  (let loop ([lines filtered-scripts] [pc 0])
	    (if (null? lines)
		bv
		(let* ([line (car lines)]
		       [op-sym (car line)]
		       [args (cdr line)]
		       [inst-val
			(case op-sym
			  ; ABC
			  [(ADD SUB MUL DIV EQ LT LE SHOW MOVE AND OR CONCAT)
			   (make-instruction-ABC (eval op-sym) (car args) (cadr args))]
			  [(JMP)
			   (let* ([target (car args)]
				  [offset
				   (if (string? target)
				       (- (hashtable-ref labels target #f) (+ pc 1))
				       target)])
			     (make-instruction-AsBx JMP 0 offset))]
			  [(TEXT) (make-instruction-ABx TEXT (car args) 0)]
			  [(WAIT (make-instruction-ABC WAIT 0 0 0))]
			  [(RAND) (make-instruction-ABC RAND (car args) (cadr args) 0)]
			  [else (error 'asm "Unknow opcode" op-sym)])])
		  (bytevector-u32-native-set! bv (* pc 4) inst-val)
		  (loop (cdr line) (+ pc 1)))))))))


  (define-syntax asm
    (syntax-rules ()
      [(_ (line ...) ...)
       (assemble '((line ...) ...))]))
  )
