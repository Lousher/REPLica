(library (core behavior)
  (export toggle attach)
  (import (chezscheme))

					; behavior is a procedure that given perticular frame, 

  (define toggle
    (lambda (ev on off) ;
      (lambda (fr)
	(if (ev fr)
	    (on fr)
	    (off fr))
	)))

  (define attach
    (lambda (ev default add-on)
      (lambda (fr)
	(if (ev fr)
	    (begin
	      (default fr)
	      (add-on fr))
	    (default fr)))))

  )
