(library (engine stage)
  (export make-stage
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

					;stage是一个input fr的函数！
  (define make-stage
    (let ([BLANK (color->Color blank)])
      (lambda (ticker ani)
	(lambda (fr)
	  (parameterize ([*PASSED* (GetTime)])
	    (load!)
	    (BeginDrawing)
	    (ClearBackground BLANK)
	    ((ani (ticker)) fr)
	    (EndDrawing)
	    )
	  ))))
					; 一个transition是一个接受两个stage,返回一整个stage的函数，其内部会用动画衔接两个stage的切换
  

  (define eternal
    (lambda (stage end?)
      (lambda (fr)
	(let loop ()
	  (unless (end? fr)
	    (let ([res (stage fr)])
	      (when res (loop)))
	    )))))

  (define sequential
    (lambda (stages pred)
      (let ([remaining stages])
	(lambda (fr)
	  (unless (null? remaining)
	    ((car remaining) fr))
	  (cond
	   [(null? remaining) #f]
	   [(and (pred fr) (not (null? remaining)))
	    (set! remaining (cdr remaining))
	    #t]
	   [(and (pred fr) (null? (cdr remaining)))
	    (set! remaining '())
	    #f]
	   )
	  ))))
  
  (define substage
    (lambda (main sub enter back)
      (let ([current main])
	(lambda (fr)
	  (current fr)
	  (cond
	   [(and (equal? current main) (enter fr))
	    (set! current sub)
	    ]
	   [(and (equal? current sub) (back fr))
	    (set! current main)
	    ])
	  #t
	  ))))

  )
