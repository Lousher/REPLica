(library (engine stage)
  (export make-stage ready
	  eternal sequential
	  substage)
  (import
   (chezscheme)
   (ffi raylib binding)
   (design color)
   (core type)
   (engine loader)
   (core ticker)
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
    (lambda (ticker ani)
      (lambda (fr)
	((ani (ticker)) fr))))
					; 一个transition是一个接受两个stage,返回一整个stage的函数，其内部会用动画衔接两个stage的切换
  
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

  )
