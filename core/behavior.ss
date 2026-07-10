(library (core behavior)
  (export toggle attach)
  (import (chezscheme))

					; behavior is a procedure that given perticular frame, 

  (define toggle
    (lambda (ev on off) ;
      (case-lambda
	[(fr)
	 (if (ev fr)
	     (on fr)
	     (off fr))]
	[()
	 (off)
	 ])))

  (define attach
    (lambda (ev default add-on)
      (case-lambda
	[(fr)
	 (if (ev fr)
	     (begin
	       (add-on fr)
	       (default fr)
	       )
	     (default fr))]
	[()
	 (default)])))

  )
