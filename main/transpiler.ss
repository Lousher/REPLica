(library (transpiler)
  (export rpl->ril)
  (import (chezscheme))

  ;; 1. 辅助函数：读取文件中的所有 S-expression
  (define (read-all-expressions filename)
    (with-input-from-file filename
      (lambda ()
        (let loop ([acc '()])
          (let ([x (read)])
            (if (eof-object? x)
                (reverse acc)
                (loop (cons x acc))))))))

  ;; 2. 核心逻辑：判断一个表达式是否为“定义/资源加载”
  ;;    根据 .rpl 文件，这些指令包括 texture, sound, transition, define 等
  (define (definition? x)
    (and (pair? x)
         (memq (car x) 
               '(texture 
                 sound 
                 transition 
                 dialogue 
                 effect 
                 phone 
                 define))))

  ;; 3. 智能文本提取：先找到所有的 dialogue 别名，再提取文本
  (define (extract-dialogue-text defs actions)
    ;; 第一步：从定义中找到所有 dialogue 的名字（例如 'speak'）
    (let ([dialogue-names 
           (map cadr (filter (lambda (x) (eq? (car x) 'dialogue)) defs))])
      
      ;; 辅助递归：在动作树中查找 (speak "...") 形式的字符串
      (let rec ([expr actions])
        (cond
          ;; 如果匹配 (dialogue-name "text" ...)
          [(and (pair? expr)
                (memq (car expr) dialogue-names)
                (string? (cadr expr)))
           (cons (cadr expr) (rec (cddr expr)))] ;; 提取字符串并继续
          
          ;; 如果是列表，递归处理所有子元素
          [(pair? expr)
           (append (rec (car expr)) (rec (cdr expr)))]
          
          [else '()]))))

  ;; 4. 主函数：转译 RPL -> RIL
  (define (rpl->ril input-path output-path)
    (let* ([exprs (read-all-expressions input-path)]
           ;; 分离定义（放在 let 头部）和动作（放入 *actions*）
           [defs (filter definition? exprs)]
           [actions (filter (lambda (x) (not (definition? x))) exprs)]
           ;; 提取文本用于生成 (*text* ...)
           [text-strings (extract-dialogue-text defs actions)])
      
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
                  (list
                   ,@(map (lambda (act) 
                            `(make-animation ,act)) 
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
