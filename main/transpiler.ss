(library (transpiler)
  (export rpl->ril)
  (import (chezscheme))

  ;; 1. 辅助函数：读取文件中的所有 S-expression
(define (read-all-expressions filename)
  (let loop ([forms '()]
             [port (open-input-file filename)]) ;; 需要更严谨的 port 管理
    (let ([x (read port)])
      (cond
       [(eof-object? x) 
        (close-input-port port)
        (reverse forms)]
       ;; === 新增逻辑：拦截 load/include ===
       [(and (pair? x) 
             (eq? (car x) 'load) 
             (string? (cadr x)))
        ;; 递归读取目标文件，并拼接到当前流中
        (let ([included-forms (read-all-expressions (cadr x))])
          (loop (append (reverse included-forms) forms) port))]
       ;; =================================
       
       [else (loop (cons x forms) port)]))))

  ;; 2. 核心逻辑：判断一个表达式是否为“定义/资源加载”
  ;;    根据 .rpl 文件，这些指令包括 texture, sound, transition, define 等
  (define (definition? x)
    (and (pair? x)
         (memq (car x) 
               '(include
		 music
		 load
		 texture 
                 sound 
                 transition 
                 dialogue 
                 effect
		 camera
                 phone
                 define
		 define-syntax
		 inspector))))

  (define directive?
    (lambda (x)
      (and (pair? x)
	   (memq (car x)
		 '(jump)))))

  (define (extract-dialogue-text actions)
    (let rec ([x actions])
      (cond
       ;; 1. 如果当前节点就是字符串，收集它
       [(string? x) (list x)]
       ;; 2. 如果是列表（S-expression），递归处理头(car)和尾(cdr)并拼接结果
       [(pair? x)
        (append (rec (car x)) (rec (cdr x)))]
       
       ;; 3. 其他情况（符号、数字、空列表等），跳过
       [else '()])))

  ;; 4. 主函数：转译 RPL -> RIL
  (define (rpl->ril input-path output-path)
    (let* ([exprs (read-all-expressions input-path)]
           ;; 分离定义（放在 let 头部）和动作（放入 *actions*）
           [defs (filter definition? exprs)]
           [actions (filter (lambda (x) (not (definition? x))) exprs)]
           ;; 提取文本用于生成 (*text* ...)
           [text-strings (extract-dialogue-text actions)])
      
      ;; 构建目标代码结构 (Quasiquote 模板)
      (let ([ril-code
             `((import (replica) (loader) (directive))
               
               ;; 生成文本预加载块
               (*text*
                (string-append ,@text-strings))
               
               ;; 生成主逻辑块
               (let ()
                 ;; 插入所有资源定义
                 ,@defs
                 ;; 插入动作列表，并自动包裹 make-animation
                 (*actions*
		  (append
		   ,@(map (lambda (act)
			    (if (directive? act) act
			    `(make-animation ,act)))
			  actions)))))])
                ;; 写入输出文件
        (with-output-to-file output-path
          (lambda ()
            (for-each (lambda (e) 
                        (pretty-print e) 
                        (newline)) 
                      ril-code))
          'replace)
        
        (display (format "Successfully transpiled ~a to ~a\n" input-path output-path)))))
)
