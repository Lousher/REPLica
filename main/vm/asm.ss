(library (vm asm)
  (export assemble asm)
  (import (vm main)
	  (chezscheme)
	  (vm isa))

  (define-syntax define-map
    (syntax-rules ()
      [(_ name (ops ...))
       (define name `((ops . ,ops) ...))]))

  (define-map OP-MAP
    (MOVE LOADK SHOW WAIT JMP
		    ADD SUB MUL DIV
		    EQ LT LE TEXT
		    AND OR NOT CONCAT RAND
		    SETZ SETS SETR))

  (define assemble
    (lambda (scripts)
      (let* ([labels (make-hashtable string-hash string=?)]
	     [const-map (make-hashtable equal-hash equal?)]
	     [const-list '()]
	     [filtered-scripts '()]
	     [inst-count 0])
	(define get-or-add-const!
	  (lambda (val)
	    (cond
	     [(hashtable-ref const-map val #f) => (lambda (idx) idx)]
	     [else
	      (let ([idx (length const-list)])
		(set! const-list (append const-list (list val)))
		(hashtable-set! const-map val idx)
		idx)])))
	; Collect Label and filter persudo cmd
	(for-each
	 (lambda (line)
	   (cond
	    [(eq? (car line) 'LABEL)
	     (hashtable-set! labels (cadr line) inst-count)]
	    [else
	     (when (eq? (car line) 'LOADK)
	       (get-or-add-const! (caddr line)))
	     (set! filtered-scripts (append filtered-scripts (list line)))
	     (set! inst-count (+ inst-count 1))]))
	 scripts)
	; Generate Code?
	(let ([bv (make-bytevector (* inst-count 4))])
	  (let loop ([lines filtered-scripts] [pc 0])
	    (if (null? lines)
		(values bv (list->vector const-list))
		(let* ([line (car lines)]
		       [op-sym (car line)]
		       [op-val (cdr (assq op-sym OP-MAP))]
		       [args (cdr line)]
		       [inst-val
			(case op-sym
			  ; ABC
			  [(ADD SUB MUL DIV EQ LT LE SHOW MOVE AND OR CONCAT)
			   (make-instruction-ABC op-val (car args) (cadr args) (caddr args))]
			  [(LOADK)
			   (let* ([reg (car args)]
				  [literal (cadr args)]
				  [idx (get-or-add-const! literal)])
                             (make-instruction-ABx op-val reg idx))]
			  [(JMP)
			   (let* ([target (car args)]
				  [offset
				   (if (string? target)
				       (- (hashtable-ref labels target #f) (+ pc 1))
				       target)])
			     (make-instruction-AsBx JMP 0 offset))]
			  [(TEXT) (make-instruction-ABC TEXT (car args) (cadr args) 0)]
			  [(WAIT) (make-instruction-ABC WAIT 0 0 0)]
			  [(SETZ SETR SETS) (make-instruction-ABC op-val (car args) 0 0)]
			  [(RAND) (make-instruction-ABC RAND (car args) (cadr args) 0)]
			  [else (error 'asm "Unknow opcode" op-sym)])])
		  (bytevector-u32-native-set! bv (* pc 4) inst-val)
		  (loop (cdr lines) (+ pc 1)))))))))


  (define-syntax asm
    (syntax-rules ()
      [(_ (line ...) ...)
       (assemble '((line ...) ...))]))
  )
