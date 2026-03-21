(library (vm main)
  (export make run
	  MOVE LOADK SHOW WAIT JMP
	  ADD SUB MUL DIV
	  EQ LT LE TEXT
	  AND OR NOT CONCAT RAND
	  SETZ
	  state-scene-root
	  state-running?
	  state-running?-set!
	  )
  (import (chezscheme)
	  (vm isa)
	  (rpl scene))

  (define-isa (MOVE LOADK SHOW WAIT JMP
		    ADD SUB MUL DIV
		    EQ LT LE TEXT
		    AND OR NOT CONCAT RAND
		    SETZ))

  (define-record-type state
    (fields
     (mutable ip)
     (immutable code)
     (immutable constants)
     (immutable registers)
     (mutable running?)
     (mutable z-index)
     (mutable scene-root)))

  (define make
    (lambda (bytecode constants)
      (make-state 0 bytecode constants (make-vector 32 #f) #t 0 (make-node-root))))

  (define-syntax case=
    (syntax-rules (else)
      [(_ key-val [key body ...] ... [else else-body ...])
       (let ([tmp key-val])
         (cond
          [(= tmp key) body ...] ...
          [else else-body ...]))]
      [(_ key-val [key body ...] ...)
       (let ([tmp key-val])
         (cond
          [(= tmp key) body ...] ...
          [else (error 'case= "No Match For" tmp)]))]))

  (define run
    (lambda (vm)
      (let* ([code (state-code vm)]
	     [regs (state-registers vm)]
	     [k-pool (state-constants vm)]
	     [len (bytevector-length code)]
	     [root (state-scene-root vm)]) ; get scene root for updating
	(let loop ([ip (state-ip vm)])
          (when (and (state-running? vm) (< ip len))
            (let* ([inst (bytevector-u32-native-ref code ip)]
                   [next-ip (+ ip 4)] [op  (decode-op inst)]
                   [a   (decode-a inst)] [b   (decode-b inst)]
                   [c   (decode-c inst)] [bx  (decode-bx inst)]
                   [sbx (decode-sbx inst)])
              ;; 使用我们自定义的高性能分发宏
              (case=
	       op
	       [ADD (vector-set! regs a (+ (vector-ref regs b) (vector-ref regs c)))
		    (loop next-ip)]
	       [SUB (vector-set! regs a (- (vector-ref regs b) (vector-ref regs c)))
		    (loop next-ip)]
	       [MUL (vector-set! regs a (* (vector-ref regs b) (vector-ref regs c)))
		    (loop next-ip)]
	       [DIV (vector-set! regs a (/ (vector-ref regs b) (vector-ref regs c)))
		    (loop next-ip)]
	       [SETZ (let ([z-val (vector-ref regs a)])
		       (if (number? z-val)
			   (state-z-index-set! vm z-val)
			   (error 'SETZ "Not a number" z-val))
		       (loop next-ip))]
	       ;; 测试失败，跳过下一条指令（通常是 JMP）
	       [EQ (let ([val-b (vector-ref regs b)] [val-c (vector-ref regs c)])
		     (if (eqv? (equal? val-b val-c) (not (zero? a)))
			 (loop next-ip)       ;; 匹配：继续执行下一条 JMP
			 (loop (+ next-ip 4)) ;; 不匹配：跳过 JMP
			 ))]
	       [LT (let ([val-b (vector-ref regs b)] [val-c (vector-ref regs c)])
		     (if (eqv? (< val-b val-c) (not (zero? a)))
			 (loop next-ip)       ;; 匹配：继续执行下一条 JMP
			 (loop (+ next-ip 4)) ;; 不匹配：跳过 JMP
			 ))]
	       [LE (let ([val-b (vector-ref regs b)] [val-c (vector-ref regs c)])
		     (if (eqv? (<= val-b val-c) (not (zero? a)))
			 (loop next-ip)       ;; 匹配：继续执行下一条 JMP
			 (loop (+ next-ip 4)) ;; 不匹配：跳过 JMP
			 ))]
	       [TEXT (let* ([id-str (vector-ref regs a)]
			    [target-id (if (string? id-str) (string->symbol id-str) id-str)]
			    [str (vector-ref regs b)]
			    [txt-node (find-node root target-id)])
		       (if txt-node
			   (scene-node-data-set! txt-node str)
			   (let ([new-txt (make-node target-id 'label 100 #f)])
			     (scene-node-data-set! new-txt str)
			     (scene-node-x-set! new-txt 100.0)
			     (scene-node-y-set! new-txt 600.0)
			     (node-add-child! root new-txt)))
		       (loop next-ip))]
	       [MOVE  (vector-set! regs a (vector-ref regs b))
		      (loop next-ip)]
	       [AND (vector-set! regs a (and (vector-ref regs b) (vector-ref regs c))) (loop next-ip)]
               [OR  (vector-set! regs a (or  (vector-ref regs b) (vector-ref regs c))) (loop next-ip)]
               [NOT (vector-set! regs a (not (vector-ref regs b))) (loop next-ip)]
	       [CONCAT (vector-set! regs a
				    (string-append (format "~a" (vector-ref regs b)) 
                                                   (format "~a" (vector-ref regs c))))
		       (loop next-ip)]
               [RAND   (vector-set! regs a (random (vector-ref regs b))) (loop next-ip)] ;; 生成 0 到 R(B)-1 的随机数
	       [LOADK (vector-set! regs a (vector-ref k-pool bx))
		      (loop next-ip)]
	       [JMP (loop (+ next-ip (* sbx 4)))]
	       [SHOW  (let* ([id (vector-ref regs a)]
			     [x  (vector-ref regs b)]
			     [y  (vector-ref regs c)]
			     [z (state-z-index vm)]
			     [new-node (make-node (string->symbol id) 'texture z id)])
			(scene-node-x-set! new-node (inexact x))
			(scene-node-y-set! new-node (inexact y))
			(node-add-child! root new-node)
			(loop next-ip))]
	       [WAIT  ;; 挂起时必须将 ip 同步回 vm 记录，以便之后恢复 
                (state-ip-set! vm next-ip)
                (state-running?-set! vm #f)
                (printf "VM Paused.\n")])
              ))))))
  
  )
