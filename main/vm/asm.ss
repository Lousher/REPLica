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
		    SETZ SETS SETR SETA SETC SETF SETP
		    LABEL PLAY
		    IN_BEG IN_CASE IN_END GRP_END
		    BUNDLE ASSET)
    )

  (define assemble
    (lambda (scripts)
      (let* ([labels (make-hashtable string-hash string=?)]
	     [const-map (make-hashtable equal-hash equal?)]
	     [const-list '()]
	     [filtered-scripts '()]
	     [inst-count 0] [const-count 0])
	(define get-or-add-const!
	  (lambda (val)
	    (cond
	     [(hashtable-ref const-map val #f) => (lambda (idx) idx)]
	     [else
	      (let ([idx const-count])
		(set! const-list (cons val const-list))
		(set! const-count (+ const-count 1))
		(hashtable-set! const-map val idx)
		idx)])))
	; Collect Label and filter persudo cmd
	(for-each
	 (lambda (line)
	   (cond
	    [(eq? (car line) 'LBL)
	     (hashtable-set! labels (cadr line) inst-count)]
	    [else
	     (when (eq? (car line) 'LOADK)
	       (get-or-add-const! (caddr line)))
	     (set! filtered-scripts (cons line filtered-scripts))
	     (set! inst-count (+ inst-count 1))]))
	 scripts)
	(set! filtered-scripts (reverse filtered-scripts))
	; Generate Code?
	(let ([bv (make-bytevector (* inst-count 4))])
	  (let loop ([lines filtered-scripts] [pc 0])
	    (if (null? lines)
		(values bv (list->vector (reverse const-list)))
		(let* ([line (car lines)]
		       [op-sym (car line)]
		       [op-val (cdr (assq op-sym OP-MAP))]
		       [args (cdr line)]
		       [inst-val
			(case op-sym
			  ; ABC
			  [(ADD SUB MUL DIV EQ LT LE SHOW MOVE AND OR CONCAT BUNDLE ASSET
				LABEL PLAY IN_BEG IN_CASE)
			   (make-instruction-ABC op-val (car args) (cadr args) (caddr args))]
			  [(SETP)
			   (make-instruction-ABC op-val (car args) (cadr args) 0)]
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
			  [(WAIT IN_END GRP_END) (make-instruction-ABC op-val 0 0 0)]
			  [(SETZ SETR SETS SETA SETC SETF) (make-instruction-ABC op-val (car args) 0 0)]
			  [(RAND) (make-instruction-ABC RAND (car args) (cadr args) 0)]
			  [else (error 'asm "Unknow opcode" op-sym)])])
		  (bytevector-u32-native-set! bv (* pc 4) inst-val)
		  (loop (cdr lines) (+ pc 1)))))))))


  (define-syntax asm
    (syntax-rules ()
      [(_ (line ...) ...)
       (assemble '((line ...) ...))]))
  )
