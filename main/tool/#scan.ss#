(library (tool scan)
  (export generate-global-codepoints)
  (import (chezscheme)) ;; 复用 eval.ss 中的 extract-script-codepoints 逻辑 [cite: 25-27]

  (define (extract-script-codepoints script-ast)
    (let ([char-hash (make-hashtable equal-hash char=?)])
      (define (traverse node)
        (cond [(pair? node) (if (eq? (car node) 'text)
                                (string-for-each (lambda (c) (hashtable-set! char-hash c #t)) (cadr node))
                                (begin (traverse (car node)) (traverse (cdr node))))]
              [(vector? node) (vector-for-each traverse node)]))
      (let loop ([i 32]) (when (< i 127) (hashtable-set! char-hash (integer->char i) #t) (loop (+ i 1))))
      (traverse script-ast)
      (list-sort < (map char->integer (vector->list (hashtable-keys char-hash))))))

  ;; 辅助函数：获取文件夹下所有的 .rpl 文件
  (define (get-rpl-files dir)
    (filter (lambda (p) (string=? (path-extension p) "rpl"))
            (directory-list dir)))

  ;; 核心函数：扫描全案字符
  (define (generate-global-codepoints script-dir)
    (let ([char-hash (make-hashtable equal-hash char=?)])
      ;; 1. 预填基础 ASCII 字符 (32-126) [cite: 27]
      (let loop ([i 32]) 
        (when (< i 127) 
          (hashtable-set! char-hash (integer->char i) #t) 
          (loop (+ i 1))))
      ;; 2. 遍历并扫描所有文件
      (let ([files (get-rpl-files script-dir)])
        (for-each
         (lambda (filename)
           (let* ([path (format "~a/~a" script-dir filename)]
                  [script-vector (with-input-from-file path 
                                   (lambda () 
                                     (let loop ([acc '()])
                                       (let ([exp (read)])
                                         (if (eof-object? exp)
                                             (list->vector (reverse acc))
                                             (loop (cons exp acc)))))))])
             
             ;; 定义扫描递归函数 (参考 eval.ss 逻辑) 
             (letrec ([traverse (lambda (node)
                                  (cond [(pair? node) 
                                         (if (eq? (car node) 'text)
                                             (string-for-each (lambda (c) (hashtable-set! char-hash c #t)) (cadr node))
                                             (begin (traverse (car node)) (traverse (cdr node))))]
                                        [(vector? node) (vector-for-each traverse node)]))])
               (traverse script-vector))))
         files))

      ;; 3. 转换为排序后的整数列表
      (let* ([all-chars (vector->list (hashtable-keys char-hash))]
             [codepoints (list-sort < (map char->integer all-chars))])
        (printf "编译完成：共提取 ~a 个唯一字符。\n" (length codepoints))
        codepoints)))

  (define (list->c-int-array lst)
    (let* ([len (length lst)] [bv (make-bytevector (* len 4))])
      (let loop ([i 0] [remaining lst])
        (if (null? remaining) bv
            (begin (bytevector-u32-set! bv (* i 4) (car remaining) (endianness little))
                   (loop (+ i 1) (cdr remaining)))))))
  )
