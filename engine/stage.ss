(library (engine stage)
  (export make-stage ready
	  eternal sequential
	  substage ensemble)
  (import
   (chezscheme)
   (ffi raylib binding)
   (design color)
   (core type)
   (engine loader)
   (core ticker)
   (core channel) 
   )

					;组合好的舞台必须要上演
  (define ready
    (let ([BLANK (color->Color blank)])
      (lambda (stage)
	(lambda (fr)
	  (parameterize ([*PASSED* (GetTime)])
	    (load!)
	    (BeginDrawing)
	    (ClearBackground BLANK)
	    (let ([res (stage fr)])
	      (EndDrawing)
	      res)
	    )
	  ))))
  
  (define make-stage
    (case-lambda
      [(ticker ani env)
       (lambda (fr)
	 (let ([t (ticker (GetTime))])
	   (let-values ([(w h) ((ani t) fr)])
	     (when env
	       ((env t) (*CHANNEL*)))
	     #t
	     )))]
      [(ticker ani)
       (make-stage ticker ani #f)]))
  
  (define eternal
    (lambda (stage end?)
      (lambda (fr)
	(let loop ()
	  (unless (end? fr)
	    (let ([res (stage fr)])
	      (when res
		(loop)))
	    )))))

  (define sequential
    (lambda (stages pred)
      (let ([remaining stages])
	(lambda (fr)
	  (if (null? remaining) #f
	      (begin
		((car remaining) fr)
		(if (pred fr)
		    (set! remaining (cdr remaining)))))
	  ))))
  
  (define substage
    (lambda (main sub enter back)
      (let ([sub-shown? #f])
	(lambda (fr)
	  (let ([res (main fr)])
	    (when sub-shown?
	      (sub fr))
	    (when (enter fr)
	      (set! sub-shown? #t))
	    (when (back fr)
	      (set! sub-shown? #f))
	    res)
	  ))))

  (define ensemble
    (lambda stages
      (lambda (fr)
	(let ([ress (map (lambda (s) (s fr)) stages)])
	  (for-all (lambda (res) (eqv? res #t)) ress)))))

  )
