(library (engine stage)
  (export
   make-stage ready
   eternal

   )
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
	(case-lambda
	  [(fr)
	   (load!)
	   (BeginDrawing)
	   (ClearBackground BLANK)
	   (stage fr)
	   (EndDrawing)
	   ]
	  [() (stage)]
	  ))))
  
  (define make-stage
    (case-lambda
      [(ticker ani env)
       (case-lambda
	 [(fr)
	  (let ([t (ticker (GetTime))])
	    (when env ((env t) (*CHANNEL*)))
	    (when ani ((ani t) fr)))]
	 [()
	  (values (ticker (GetTime))
		  'default)])]
      [(ticker ani)
       (make-stage ticker ani #f)]))
  
  (define eternal ;; 在stage结束前，一直上演
    (lambda (stage end?)
      (case-lambda
	[(fr)
	 (let loop ()
	   (unless (end? fr)
	     (let-values ([(p status) (stage)])
	       (when p
		 (stage fr)
		 (loop)))))]
	[() (stage)])))
  )
