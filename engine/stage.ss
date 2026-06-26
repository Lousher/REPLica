(library (engine stage)
  (export ticker->stage
	  eternal sequential
	  substage)
  (import
   (chezscheme)
   (ffi raylib binding)
   (design color)
   (core type)
   (engine loader)
   (core ticker))

					;stage是一个input fr的函数！
  (define ticker->stage
    (let ([BLANK (color->Color blank)])
      (lambda (ticker)
	(lambda (fr)
	  (parameterize ([*PASSED* (GetTime)])
	    (load!)
	    (BeginDrawing)
	    (ClearBackground BLANK)
	    (ticker fr)
	    (EndDrawing)
	    )
	  ))))

  (define eternal
    (lambda (stage end?)
      (lambda (fr)
	(let loop ()
	  (unless (end? fr)
	    (stage fr)
	    (loop)
	    )))))

  (define sequential
    (lambda (pred . stages)
      (let ([remaining stages])
	(lambda (fr)
	  (unless (null? remaining)
	    ((car remaining) fr)
	    (when (pred fr)
	      (set! remaining (cdr remaining))))
	  ))))
  
  (define substage
    (lambda (main sub enter back)
      (let ([current main])
	(lambda (fr)
	  (current fr)
	  (cond
	   [(and (equal? current main) (enter fr))
	    (set! current sub)]
	   [(and (equal? current sub) (back fr))
	    (set! current main)])
	  ))))
  )
