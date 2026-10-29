(import (chezscheme))

;; ---------- 辅助取值 ----------
(define field
  (lambda (key alist)
    (let ([pair (assv key alist)])
      (if pair
          (let ([rest (cdr pair)])
            (if (pair? rest) (car rest) rest))
          #f))))

;; ---------- tools ----------
(define string-trim
  (lambda (str)
    (let ([len (string-length str)])
      (let loop ([start 0])
        (if (and (< start len) (char-whitespace? (string-ref str start)))
            (loop (+ start 1))
            (let end-cal ([end len])
              (if (and (> end start) (char-whitespace? (string-ref str (- end 1))))
                  (end-cal (- end 1))
                  (substring str start end))))))))
(define string-starts-with?
  (lambda (str prefix)
    (let ([len-s (string-length str)] [len-p (string-length prefix)])
      (and (>= len-s len-p)
           (string=? (substring str 0 len-p) prefix)))))
(define string-ends-with?
  (lambda (str suffix)
    (let ([len-s (string-length str)] [len-suf (string-length suffix)])
      (and (>= len-s len-suf)
           (string=? (substring str (- len-s len-suf) len-s) suffix)))))
(define index-of
  (lambda (char s)
    (let ([len (string-length s)])
      (let loop ([i 0])
        (cond [(= i len) #f]
              [(char=? (string-ref s i) char) i]
              [else (loop (+ i 1))])))))
(define (remove-duplicates lst)
  (let loop ([l lst] [seen '()])
    (cond [(null? l) (reverse seen)]
          [(member (car l) seen) (loop (cdr l) seen)]
          [else (loop (cdr l) (cons (car l) seen))])))

;; ---------- 全局：多重指针 ftype 注册表 ----------
(define pointer-ftypes '())

(define (intern-pointer base-sym)
  (let* ([name-str (string-append "*" (symbol->string base-sym))]
         [name (string->symbol name-str)])
    (unless (assv name pointer-ftypes)
      (set! pointer-ftypes (cons (cons name base-sym) pointer-ftypes)))
    name))

;; ---------- C type -> Chez ftype ----------
(define (ctype->ftype ctype)
  (let* ([t (if (string-starts-with? ctype "const ")
                (string-trim (substring ctype 6 (string-length ctype)))
                ctype)]
         [simple
          (case t
            [("int") 'integer-32]
            [("long") 'long]
            [("float") 'single-float]
            [("double") 'double-float]
            [("char") 'char]
            [("bool") 'boolean]
            [("void") 'void]
            [("unsigned char") 'unsigned-8]
            [("unsigned short") 'unsigned-16]
            [("unsigned int") 'unsigned-32]
            [("char *") 'string]
            [("void *" "va_list") 'void*]
            [else #f])])
    (or simple
        (cond
         [(and (index-of #\[ t) (index-of #\] t))
          (let* ([i1 (index-of #\[ t)] [i2 (index-of #\] t)]
                 [base (substring t 0 i1)]
                 [len (string->number (substring t (+ i1 1) i2))])
            `(array ,len ,(ctype->ftype base)))]
         [(string-ends-with? t "*")
          (let* ([base (string-trim (substring t 0 (- (string-length t) 1)))]
                 [base-spec (ctype->ftype base)])
            (cond
             [(eq? base-spec 'string) '(* (* char))]  ; char** 用原始 char*
             [else `(* ,base-spec)]))]
         [else (string->symbol t)]))))

(define (ctype->ftype-struct ctype)
  (let* ([t (if (string-starts-with? ctype "const ")
                (string-trim (substring ctype 6 (string-length ctype)))
                ctype)]
         [simple
          (case t
            [("int") 'integer-32]
            [("long") 'long]
            [("float") 'single-float]
            [("double") 'double-float]
            [("char") 'char]
            [("bool") 'boolean]
            [("void") 'void]
            [("unsigned char") 'unsigned-8]
            [("unsigned short") 'unsigned-16]
            [("unsigned int") 'unsigned-32]
            [("char *") 'string]
            [("void *" "va_list") 'void*]
            [else #f])])
    (or simple
        (cond
         [(and (index-of #\[ t) (index-of #\] t))
          (let* ([i1 (index-of #\[ t)] [i2 (index-of #\] t)]
                 [base (substring t 0 i1)]
                 [len (string->number (substring t (+ i1 1) i2))])
            `(array ,len ,(ctype->ftype base)))]
         [(string-ends-with? t "*")
          (let* ([base (string-trim (substring t 0 (- (string-length t) 1)))]
                 [base-spec (ctype->ftype-struct base)])
            (cond
             [(eq? base-spec 'string) '(* (* char))]
             [else `(* ,base-spec)]))]
         [else (string->symbol t)]))))

;; ---------- foreign-procedure 类型归一化 ----------
;; (* X) → 保留；(* (* X)) → (* *X)，并注册 *X = (* X)
(define (normalize-pointer-spec spec)
  (cond
   [(not (pair? spec)) spec]
   [(eq? (car spec) '*)
    (let ([inner (cadr spec)])
      (cond
       [(symbol? inner) spec]
       [(and (pair? inner) (eq? (car inner) '*))
        (let ([x (cadr inner)])
          (if (symbol? x)
              `(* ,(intern-pointer x))
              spec))]
       [else spec]))]
   [else spec]))

;; ---------- defines / enums ----------
(define (build-defines defs)
  (map (lambda (d)
         (let ([name (string->symbol (field 'name d))]
               [val  (field 'value d)])
           `(define ,name ,val)))
       (filter (lambda (d)
                 (case (field 'type d)
                   [("INT" "FLOAT" "DOUBLE" "STRING") #t]
                   [else #f]))
               defs)))

(define (build-enums enums)
  (apply append
         (map (lambda (e)
                (let ([vals (cdr (assv 'values e))])
                  (map (lambda (v)
                         (let ([name (string->symbol (field 'name v))]
                               [val  (field 'value v)])
                           `(define ,name ,val)))
                       vals)))
              enums)))

;; ---------- callbacks ----------
(define (build-callbacks callbacks)
  (map (lambda (c)
         (let ([name (string->symbol (field 'name c))]
               [ret  (normalize-pointer-spec (ctype->ftype (field 'return-type c)))]
               [params (cdr (assv 'params c))])
           `(define-ftype ,name
              (function ,(map (lambda (p)
                                (normalize-pointer-spec
                                 (ctype->ftype (field 'type p))))
                              params)
                        ,ret))))
       callbacks))

;; ---------- structs + aliases（交错输出） ----------
(define (build-struct-exp s)
  (let* ([name (string->symbol (field 'name s))]
         [fields-pair (assv 'fields s)]
         [fields (if fields-pair (cdr fields-pair) '())])
    `(define-ftype ,name
       (struct
         ,@(map (lambda (f)
                  (let ([f-name (string->symbol (field 'name f))]
                        [f-type (ctype->ftype-struct (field 'type f))])
                    `[,f-name ,f-type]))
                fields)))))

(define (alias-base a)
  (let* ([type-str (string-trim (field 'type a))])
    (if (string-ends-with? type-str "*")
        (string-trim (substring type-str 0 (- (string-length type-str) 1)))
        type-str)))

(define (build-alias-exp a)
  (let* ([name (field 'name a)]
         [type-str (string-trim (field 'type a))]
         [name-sym (string->symbol name)])
    (if (string-ends-with? type-str "*")
        (let* ([base (string-trim (substring type-str 0 (- (string-length type-str) 1)))]
               [base-sym (string->symbol base)])
          `(define-ftype ,name-sym (* ,base-sym)))
        `(alias ,name-sym ,(string->symbol type-str)))))

(define (build-structs-and-aliases structs aliases)
  (apply append
         (map (lambda (s)
                (let* ([s-name (field 'name s)]
                       [struct-exp (build-struct-exp s)]
                       [related
                        (filter (lambda (a) (equal? (alias-base a) s-name))
                                aliases)]
                       [alias-exps (map build-alias-exp related)])
                  (cons struct-exp alias-exps)))
              structs)))

;; ---------- 收集 struct 字段的原始 C 类型名 ----------
(define (collect-field-ctypes structs)
  (apply append
         (map (lambda (s)
                (let ([fp (assv 'fields s)])
                  (if fp
                      (map (lambda (f) (field 'type f)) (cdr fp))
                      '())))
              structs)))

(define (ctype-str->type-name type-str)
  (let* ([s (if (string-starts-with? type-str "const ")
                (substring type-str 6 (string-length type-str))
                type-str)]
         [s (string-trim s)]
         [s (let ([i (index-of #\[ s)])
              (if i (string-trim (substring s 0 i)) s))]
         [s (let loop ([s s])
              (if (string-ends-with? s "*")
                  (loop (string-trim (substring s 0 (- (string-length s) 1))))
                  s))])
    s))

;; ---------- 函数 ----------
(define (has-uppercase? str)
  (exists char-upper-case? (string->list str)))

(define (filter-variadic params)
  (filter (lambda (p) (not (equal? (field 'type p) "..."))) params))

(define (build-functions funcs)
  (map (lambda (f)
         (let* ([name-str (field 'name f)]
                [name     (string->symbol name-str)]
                [raw-ret  (ctype->ftype (field 'return-type f))]
                [params-pair (assv 'params f)]
                [params (if params-pair (filter-variadic (cdr params-pair)) '())]
                [arg-types (map (lambda (p) (ctype->ftype (field 'type p))) params)]
                [arg-ftypes (map (lambda (t)
                                   (cond
                                    [(and (symbol? t)
                                          (string-ends-with? (symbol->string t) "Callback"))
                                     `(* ,t)]
                                    [(and (symbol? t)
                                          (has-uppercase? (symbol->string t)))
                                     `(& ,t)]
                                    [else (normalize-pointer-spec t)]))
                                 arg-types)])
           (if (and (symbol? raw-ret)
                    (has-uppercase? (symbol->string raw-ret)))
               ;; struct 返回：第一个参数为 ret 指针，返回 void
               `(define ,name
                  (let ([proc (foreign-procedure
                               #f ,name-str
                               ((& ,raw-ret) ,@arg-ftypes)
                               void)])
                    (lambda xargs
                      (let ([ret-res (make-ftype-pointer
                                      ,raw-ret
                                      (foreign-alloc (ftype-sizeof ,raw-ret)))])
                        (apply proc ret-res xargs)
                        ret-res))))
               (let ([ret (normalize-pointer-spec raw-ret)])
                 `(define ,name
                    (foreign-procedure #f ,name-str
                                       (,@arg-ftypes)
                                       ,ret))))))
       (filter (lambda (func) (foreign-entry? (field 'name func))) funcs)))

;; ---------- 主流程 ----------
(define (build-raylib-library lib in out)
  (display "Loading Raylib dynamic library\n")
  (load-shared-object lib)
  (assert (foreign-entry? "InitWindow"))
  (display "Reading data ...\n")
  (let* ([raw (with-input-from-file in read)]
         [defs      (cdr (assv 'defines raw))]
         [structs   (cdr (assv 'structs raw))]
         [aliases   (cdr (assv 'aliases raw))]
         [enums     (cdr (assv 'enums raw))]
         [callbacks (cdr (assv 'callbacks raw))]
         [funcs     (cdr (assv 'functions raw))])

    (set! pointer-ftypes '())

    (let* ([def-exps          (build-defines defs)]
           [enum-exps         (build-enums enums)]
           [callback-exps     (build-callbacks callbacks)]
           [struct-alias-exps (build-structs-and-aliases structs aliases)]
           [func-exps         (build-functions funcs)]   ; 可能注册 pointer-ftypes

           [struct-names (map (lambda (s) (string->symbol (field 'name s))) structs)]
           [alias-names  (map (lambda (a) (string->symbol (field 'name a))) aliases)]
           [defined-types (append struct-names alias-names)]

           [field-ctypes   (collect-field-ctypes structs)]
           [candidate-strs (map ctype-str->type-name field-ctypes)]
           [simple-builtins '("char" "int" "long" "float" "double" "void"
                              "bool" "unsigned char" "unsigned short" "unsigned int"
                              "va_list" "FILE" "size_t" "intptr_t" "uintptr_t")]
           [undefined-types
            (remove-duplicates
             (filter (lambda (t)
                       (and (symbol? t)
                            (has-uppercase? (symbol->string t))
                            (not (member t defined-types))))
                     (map string->symbol
                          (filter (lambda (s)
                                    (and (> (string-length s) 0)
                                         (not (member s simple-builtins))))
                                  candidate-strs))))]

           [all-exported-names
            (map cadr
                 (filter (lambda (exp)
                           (and (pair? exp) (>= (length exp) 2)
                                (memv (car exp) '(define alias define-ftype))))
                         (append def-exps enum-exps callback-exps
                                 struct-alias-exps func-exps)))])

      (display "Generating Raylib bindings ...\n")
      (let ([lib-expr
             `(library (ffi raylib binding)
                (export ,@all-exported-names)
                (import (chezscheme))

                ,@def-exps
                ,@enum-exps

                ;; 未知内部类型的前向空 struct 声明（rAudioBuffer 等）
                ,@(map (lambda (t) `(define-ftype ,t (struct)))
                       undefined-types)

                ;; callbacks（参数均为内建类型，不依赖 struct）
                ,@callback-exps

                ;; structs 与 aliases 交错输出
                ;; 例：Texture 后紧跟 Texture2D/TextureCubemap；
                ;;     Transform 后紧跟 ModelAnimPose
                ,@struct-alias-exps

                ;; 多重指针别名：*Rectangle = (* Rectangle)
                ;; 供 foreign-procedure 的 (* *Rectangle) 等参数使用
                ,@(map (lambda (pair)
                         `(define-ftype ,(car pair) (* ,(cdr pair))))
                       (reverse pointer-ftypes))

                ;; 外部函数
                ,@func-exps)])
        (display "Pretty Printing ...\n")
        (with-output-to-file out (lambda () (pretty-print lib-expr)) 'replace)
        (display "Done! Build Successfully\n")))))

(build-raylib-library
 "../ffi/raylib/libraylib.so.6.2.0"
 "./raylib_api.sexpr"
 "../ffi/raylib/binding.ss")
