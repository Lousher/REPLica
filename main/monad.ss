(library (monad)
  (export bind return perform ref put modify sequence <-)
  (import (chezscheme))

  (define-syntax <-
    (syntax-rules ()
      [(_ . args) (error '<- "Misplaced auxiliary keyword <-")]))

  (define bind
    (lambda (action next-f)
      (lambda (state)
	(let-values ([(val new-state) (action state)])
	  ((next-f val) new-state))))) 

  (define return
    (lambda (val)
      (lambda (state)
	(values val state ))))

  (define-syntax perform
    (syntax-rules (<-)
      [(_ expr) expr]
      [(_ (var <- action) rest ...)
       (bind action (lambda (var) (perform rest ...)))]
      [(_ action rest ...)
       (bind action (lambda (_) (perform rest ...)))]))

  (define ref
    (lambda (state)
      (values state state)))

  (define put
    (lambda (new-state)
      (lambda (old-state)
	(values 'ok new-state))))

  (define modify
    (lambda (f)
      (lambda (state)
	(values 'modify (f state)))))

  (define sequence
    (lambda actions
      (cond
       [(null? actions) (return '())]
       [(null? (cdr actions)) (car actions)]
       [else (perform
	      (car actions)
	      (apply sequence (cdr actions)))])))
  
  )
