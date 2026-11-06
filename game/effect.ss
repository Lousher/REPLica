(library (game effect)
  (export handler-claim?
   effect? effect-deps effect-execute!)
  (import (chezscheme)
	  (game picture)
	  (game clip)
	  (game window)
	  (ffi raylib binding))

  #| claim? judging effect type, accept? judging context type |#
  (define-record-type handler
    (fields claim? accept? executer deps)) ; all funcs
  
  (define REGISTRY '())

  (define register-effect
    (lambda (claim? accept? executer deps)
      (set! REGISTRY
	    (cons (make-handler claim? accept? executer deps)
		  REGISTRY))))

  (define handler-ref
    (lambda (e)
      (find (lambda (h)
	      ((handler-claim? h) e))
	    REGISTRY)))

  (define effect?
    (lambda (e)
      (if (handler-ref e) #t #f)))

  (define effect-deps
    (lambda (e)
      (let ([h (handler-ref e)])
	(if h
	    ((handler-deps h) e)
	    (error 'effect-deps "Unknown effect" e)))))

  (define effect-execute!
    (lambda (e . ctxs)
      (let ([h (handler-ref e)])
	(if h
	    (let ([matched-ctx (find (handler-accept? h) ctxs)])
	      (if matched-ctx
		  ((handler-executer h) e matched-ctx)
		  (error 'effect-execute! "No matching context" e)))
	    (error 'effect-execute! "Unknow effect" e)))))
  
  #| begin registry |#

  (register-effect
   picture? frame?
   (lambda (pic frame)
     ((picture-drawer pic) frame))
   picture-deps)

  (register-effect
   clip? channel?
   (lambda (cp chl)
     ((clip-player cp) chl))
   clip-deps)

  )
