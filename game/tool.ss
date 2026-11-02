(library (game tool)
  (export zf)
  (import (chezscheme))

  (define ZF_SCRIPT "./game/script/zf")
  (define zf
    (lambda (candidates . queries)
      (let* ([cmd (format "~a -f '~{~a~^ ~}'" ZF_SCRIPT queries)])
	(let-values ([(stdin stdout stderr pid)	(open-process-ports cmd (buffer-mode block) (native-transcoder))])
	  (let ([first-match #f] [err #f])
	    (let ([reader (fork-thread
			   (lambda ()
			     (set! first-match (get-line stdout))
			     (close-input-port stdout)))]
		  [writer (fork-thread
			   (lambda ()
			     (guard (e [#t (void)])
			       (dynamic-wind
				 void
				 (lambda ()
				   (for-each (lambda (c) (display c stdin) (newline stdin)) candidates))
				 (lambda () (close-output-port stdin))))))]
		  [err-reader (fork-thread
			       (lambda ()
				 (set! err (get-string-all stderr))))])
	      (thread-join reader)
	      (thread-join writer)
	      (thread-join err-reader)
	      (cond
	       [(and (string? err) (not (string=? "" err))) (error 'zf "[ZF] Error" err)]
	       [(eof-object? first-match) #f]
	       [else first-match])))))
      ))
  )
