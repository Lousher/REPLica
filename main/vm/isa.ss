(library (vm isa)
  (export define-isa make-instruction-ABC make-instruction-ABx make-instruction-AsBx
	  decode-op decode-a decode-b decode-c decode-bx decode-sbx)
  (import (chezscheme))

  ;; 格式: [ B: 9 bits | C: 9 bits | A: 8 bits | OP: 6 bits ]
  (define make-instruction-ABC
    (lambda (op A B C)
      (unless (and (<= 0 A 255) (<= 0 B 511) (<= 0 C 511))
	(error 'make-instruction "Operand out of bounds" A B C))
      (bitwise-ior op
		   (bitwise-arithmetic-shift-left A 6)
		   (bitwise-arithmetic-shift-left C 14)
		   (bitwise-arithmetic-shift-left B 23))))

  (define make-instruction-ABx
    (lambda (op A Bx)
      (bitwise-ior op
		   (bitwise-arithmetic-shift-left A 6)
		   (bitwise-arithmetic-shift-left Bx 14))))

  (define make-instruction-AsBx
    (lambda (op A sbx)
      (make-instruction-ABx op A (+ sbx #x1FFFF))))

  (define-syntax decode-op (syntax-rules () [(_ i) (bitwise-and i #x3F)]))          ; 6 bits
  (define-syntax decode-a  (syntax-rules () [(_ i) (bitwise-and (bitwise-arithmetic-shift-right i 6) #xFF)])) ; 8 bits
  (define-syntax decode-c  (syntax-rules () [(_ i) (bitwise-and (bitwise-arithmetic-shift-right i 14) #x1FF)])) ; 9 bits
  (define-syntax decode-b  (syntax-rules () [(_ i) (bitwise-and (bitwise-arithmetic-shift-right i 23) #x1FF)])) ; 9 bits
  (define-syntax decode-bx (syntax-rules () [(_ i) (bitwise-and (bitwise-arithmetic-shift-right i 14) #x3FFFF)])) ; 18 bits [cite: 493]

  (define-syntax decode-sbx (syntax-rules () [(_ i) (- (decode-bx i) #x1FFFF)]))

  (define-syntax define-isa
    (lambda (x)
      (syntax-case x ()
        [(_ (name ...))
         (with-syntax ([(val ...) 
                        (let loop ([n 0] [lst #'(name ...)])
                          (if (null? lst)
                              '()
                              (cons n (loop (+ n 1) (cdr lst)))))])
           #'(begin
               (define name val) ...))])))
  )
