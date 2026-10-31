(library (game type)
  (export make-color color? Color<=color color<=Color
	  make-rectangle rectangle? Rectangle<=rectangle rectangle<=Rectangle
	  make-vector2 vector? Vector2<=vector2 vector2<=Vector2)
  (import (chezscheme)
	  (ffi raylib binding))

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ type)
       (make-ftype-pointer type (foreign-alloc (ftype-sizeof type)))
       ]))

  (define-syntax ftype-fields ; at run time
    (syntax-rules ()
      [(_ type)
       (let* ([fptr (ftype-alloc type)]
	      [struct-li (ftype-pointer-ftype fptr)])
	 (foreign-free (ftype-pointer-address fptr))
	 (map car (cdr struct-li)))]))

  
  (define-syntax format-id
    (syntax-rules ()
      [(_ ctx str arg ...)
       (datum->syntax ctx (string->symbol (format str arg ...)))]))
  
  (define-syntax define-ftype-record
    (lambda (x)
      (syntax-case x ()
	[(key type name (field ...) type->rcd rcd->type)
	 (let ([rcd (syntax->datum #'name)])
	   (with-syntax ([ctor (format-id #'key "make-~a" (syntax->datum #'name))]
			 [(acc ...) (map (lambda (f) (format-id #'key "~a-~a" (syntax->datum #'name) f)) (syntax->datum #'(field ...)))])
	     #'(begin
		 (define-record-type name (fields field ...))
		 (define rcd->type
		   (case-lambda
		     [(record fptr)
		      (ftype-set! type (field) fptr (acc record)) ...
		      fptr]
		     [(record)
		      (rcd->type (ftype-alloc type))]))
		 (define type->rcd
		   (lambda (T)
		     (let ([field (ftype-ref type (field) T)] ...)
		       (ctor field ...)))))))])))

  (define-ftype-record Color color (r g b a) color<=Color Color<=color)
  (define-ftype-record Rectangle rectangle (x y width height) rectangle<=Rectangle Rectangle<=rectangle)
  (define-ftype-record Vector2 vector2 (x y) vector2<=Vector2 Vector2<=vector2)
  
  )
