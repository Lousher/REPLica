(define (hello) 'world)

(define (world) (hello))

(world)

(define-syntax when
  (syntax-rules ()
    [(_ test exp ...)
     (if test
	 (begin
	   exp ...)
	 #f)]))



