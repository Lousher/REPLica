(import (chezscheme))

					;过滤掉chez中不兼容的define
(define build-defines
  (lambda (defs)
    (map (lambda (d)
	   (let ([name (string->symbol (cdr (assv 'name d)))]
		 [type (cdr (assv 'type d))]
		 [val (cdr (assv 'value d))])
	     `(define ,name ,val)
	     ))
	 (filter (lambda (d)
		   (case (cdr (assv 'type d))
		     [("INT" "FLOAT" "DOUBLE" "STRING")
		      #t]
		     [("GUARD" "MACRO" "UNKNOWN" "FLOAT_MATH" "COLOR")
		      #f])) defs))
    ))

					;直接作为常量拼接
(define build-enums
  (lambda (enums)
    (apply append
	   (map
	    (lambda (e)
	      (let ([vals (cdr (assv 'values e))])
		(map (lambda (v)
		       (let ([name (string->symbol (cdr (assv 'name v)))]
			     [val (cdr (assv 'value v))])
			 `(define ,name ,val)))
		     vals)))
	    enums))))

					;alias 
(define build-aliases
  (lambda (alises)
    (map (lambda (a)
	   (let* ([name-str (cdr (assv 'name a))]
		  [type-str (cdr (assv 'type a))]
		  [is-pointer-name (string-starts-with? name-str "*")]
		  [clean-name (if is-pointer-name
				  (substring name-str 1 (string-length name-str))
				  name-str)]
		  [new-type (if is-pointer-name
				`(* ,(string->symbol type-str))
				(string->symbol type-str))]
		  )
	     (if is-pointer-name
		 `(define-ftype ,(string->symbol clean-name) ,new-type)
		 `(alias ,(string->symbol clean-name) ,new-type))))
	 alises)))
					; tools
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
    (let ([len-s (string-length str)]
	  [len-p (string-length prefix)])
      (and (>= len-s len-p)
	   (string=? (substring str 0 len-p) prefix)))))
(define string-ends-with?
  (lambda (str suffix)
    (let ([len-s (string-length str)]
	  [len-suf (string-length suffix)])
      (and (>= len-s len-suf)
	   (string=? (substring str (- len-s len-suf) len-s) suffix)))))
(define index-of
  (lambda (char s)
    (let ([len (string-length s)])
      (let loop ([i 0])
	(cond
	 [(= i len) #f]
	 [(char=? (string-ref s i) char) i]
	 [else (loop (+ i 1))])))))

(define ctype->ftype
  (lambda (ctype)
    (let ([t (if (string-starts-with? ctype "const ")
		 (string-trim (substring ctype 6 (string-length ctype)))
		 ctype)])
      (let ([simple
	     (case t
	       [("int") 'integer-32]
	       [("float") 'single-float]
	       [("double") 'double-float]
	       [("char") 'char]
	       [("bool") 'boolean]
	       [("void") 'void]
	       [("unsigned char") 'unsigned-8]
	       [("unsigned short") 'unsigned-16]
	       [("unsigned int") 'unsigned-32]
	       [("char *" "char **") 'string]
	       [("void *" "va_list") 'void*]
	       [("...") 'variadic]
	       [else #f])])
	(if simple simple
	    (cond
	     [(and (index-of #\[ t) (index-of #\] t))
	      (let* ([idx1 (index-of #\[ t)]
		     [idx2 (index-of #\] t)]
		     [base (substring t 0 idx1)]
		     [len (string->number (substring t (+ idx1 1) idx2))])
		`(array ,len ,(ctype->ftype base)))]
					;更复杂的，除开void* 和char* char **外的
	     [(string-ends-with? t "*")
	      (let ([base (string-trim (substring t 0 (- (string-length t) 1)))])
		`(* ,(ctype->ftype base)))]
	     [else (string->symbol t)])))
      )))

(define ctype->ftype-struct
  (lambda (ctype)
    (let ([t (if (string-starts-with? ctype "const ")
		 (string-trim (substring ctype 6 (string-length ctype)))
		 ctype)])
      (let ([simple
	     (case t
	       [("int") 'integer-32]
	       [("float") 'single-float]
	       [("double") 'double-float]
	       [("char") 'char]
	       [("bool") 'boolean]
	       [("void") 'void]
	       [("unsigned char") 'unsigned-8]
	       [("unsigned short") 'unsigned-16]
	       [("unsigned int") 'unsigned-32]
	       [("void *" "va_list") 'void*]
	       [else #f])])
	(if simple simple
	    (cond
	     [(and (index-of #\[ t) (index-of #\] t))
	      (let* ([idx1 (index-of #\[ t)]
		     [idx2 (index-of #\] t)]
		     [base (substring t 0 idx1)]
		     [len (string->number (substring t (+ idx1 1) idx2))])
		`(array ,len ,(ctype->ftype base)))]
					;更复杂的，除开void* 和char* char **外的
	     [(string-ends-with? t "*")
	      (let ([base (string-trim (substring t 0 (- (string-length t) 1)))])
		`(* ,(ctype->ftype-struct base)))]
	     [else (string->symbol t)])))
      )))
					;callbacks
(define build-callbacks
  (lambda (callbacks)
    (map (lambda (c)
	   (let ([name (string->symbol (cdr (assv 'name c)))]
		 [ret-type (ctype->ftype (cdr (assv 'returnType c)))]
		 [params (cdr (assv 'params c))])
	     `(define-ftype ,name
		(function ,(map (lambda (p)
				  (ctype->ftype (cdr (assv 'type p))))
				params)
			  ,ret-type))))
	 callbacks)))

					;struct 前置声明
(define build-struct-declarations
  (lambda (structs)
    (map (lambda (s)
	   `(define ,(string->symbol (cdr (assv 'name s)))
	      ))
	 structs)))

(define build-structs
  (lambda (structs alises)
    (let ([alias-exps (build-aliases alises)])
      (apply append
	     (map (lambda (s)
		    (let* ([name (string->symbol (cdr (assv 'name s)))]
			   [fields-pair (assv 'fields s)]
			   [fields (if fields-pair (cdr fields-pair) '())]
			   [alias-exp
			    (filter
			     (lambda (a)
			       (if (list? (caddr a))
				   (member name (caddr a))
				   (eqv? name (caddr a))
				   )) alias-exps)])
		      (if alias-exp
			  `((define-ftype ,name
			      (struct
				,@(map (lambda (f)
					 (let ([f-name (string->symbol (cdr (assv 'name f)))]
					       [f-type (ctype->ftype-struct (cdr (assv 'type f)))])
					   `[,f-name ,f-type]))
				       fields)))
			    ,@alias-exp)
			  `((define-ftype ,name
			      (struct
				,@(map (lambda (f)
					 (let ([f-name (string->symbol (cdr (assv 'name f)))]
					       [f-type (ctype->ftype-struct (cdr (assv 'type f)))])
					   `[,f-name ,f-type]))
				       fields))))
			  )))
		  structs)))))

					; 补全类似rAudioBuffer的内部struct
(define collect-used-ctypes
  (lambda (structs)
    (fold-left
     (lambda (acc s)
       (let ([fields (cdr (assv 'fields s))])
	 (fold-left
	  (lambda (inner-acc f)
	    (let ([type (cdr (assv 'type f))])
	      (if (member type inner-acc)
		  inner-acc
		  (cons type inner-acc))))
	  acc
	  (cdr (assv 'fields s))
	  )))
     '()
     structs))
  )

(define has-uppercase?
  (lambda (str)
    (exists char-upper-case? (string->list str))))

(define build-functions
  (lambda (funcs)
    (map (lambda (f)
	   (let* ([name-str (cdr (assv 'name f))]
		  [name (string->symbol name-str)]
		  [ret-type (ctype->ftype (cdr (assv 'returnType f)))]
		  [params-pair (assv 'params f)]
		  [params (if params-pair (cdr params-pair) '())]
		  [arg-types
		   (filter (lambda (rp) (not (eqv? rp 'variadic))) (map (lambda (p) (ctype->ftype (cdr (assv 'type p)))) params))])
	     (if (and (symbol? ret-type)
		      (has-uppercase? (symbol->string ret-type)))
		 `(define ,name
		    (let ([proc (foreign-procedure
				 #f ,name-str
				 (,@(map
				     (lambda (t)
				       (cond
					[(and (symbol? t) (string-ends-with? (symbol->string t) "Callback"))
					 `(* ,t)]
					[(and (symbol? t) (has-uppercase? (symbol->string t))) 
					 `(& ,t)]
					[else 
					 t]))
				     arg-types))(& ,ret-type))])
		      (lambda xargs
			(let ([ret-res (make-ftype-pointer ,ret-type (foreign-alloc (ftype-sizeof ,ret-type)))])
			  (apply proc ret-res xargs)
			  ret-res))))
		 `(define ,name
		    (foreign-procedure #f ,name-str (,@(map
							(lambda (t)
							  (cond
							   [(and (symbol? t) (string-ends-with? (symbol->string t) "Callback"))
							    `(* ,t)]
							   [(and (symbol? t) (has-uppercase? (symbol->string t))) 
							    `(& ,t)]
							   [else 
							    t]))
							arg-types)) ,ret-type)))))
	 (filter
	  (lambda (func)
	    (foreign-entry? (cdr (assv 'name func))))
	  funcs))))

(define build-raylib-library
  (lambda (lib in out)
    (display "Loading Raylib dynamic library\n")
    (load-shared-object lib)
    (assert (foreign-entry? "InitWindow"))
    (display "Reading data ...\n")
    (let* ([raw (with-input-from-file in read)]
	   [defs (cdr (assv 'defines raw))]
	   [enums (cdr (assv 'enums raw))]
	   [aliases (cdr (assv 'aliases raw))]
	   [callbacks (cdr (assv 'callbacks raw))]
	   [structs (cdr (assv 'structs raw))]
	   [funcs (cdr (assv 'functions raw))]
	   [def-exps (build-defines defs)]
	   [enum-exps (build-enums enums)]
	   [struct-decl-exps (build-struct-declarations structs)]
	   [aliase-exps (build-aliases aliases)]
	   [callback-exps (build-callbacks callbacks)]
	   [struct-exps (build-structs structs aliases)]
	   [func-exps (build-functions funcs)]
	   [used-types (map (lambda (t) (if (list? t) (car (last-pair t)) t)) (map ctype->ftype (collect-used-ctypes (cdr structs))))]
	   [defined-types (map cadr (append struct-decl-exps aliase-exps))]
	   [undefined-types (filter (lambda (t)
				      (and (exists char-upper-case? (string->list (symbol->string t)))
					   (not (member t defined-types)))) used-types)]
	   
	   [all-exported-names
	    (map cadr
		 (filter (lambda (exp)
			   (if (and (list exp) (>= (length exp) 2)
				    (memv (car exp) '(define alias define-ftype)))
			       #t
			       #f))
			 (append def-exps enum-exps struct-decl-exps aliase-exps callback-exps func-exps)))])
      (display "Generating Raylib bindings ...")
      (newline)
      (let ([lib-expr
	     `(library (ffi raylib binding)
		(export ,@all-exported-names)
		(import (chezscheme))

		,@def-exps

		,@enum-exps

		,@(map (lambda (t)
			 `(define-ftype ,t (struct)))
		       undefined-types)
		
					;		,@aliase-exps
		
					;		,@struct-decl-exps

		,@callback-exps

		,@struct-exps
		


		,@func-exps
		)])
	(display "Pretty Printing ...\n")
	(with-output-to-file out
	  (lambda ()
	    (pretty-print lib-expr))
	  'replace)
	(display "Done! Build Successfully\n")
	))))

(begin
  (build-raylib-library "libraylib.so.6.0.0" "store/raylib_api.pretty.ss" "binding.ss"))

