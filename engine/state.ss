(library (engine state)
  (export make-state
	  state?
	  state-pc state-pc-set!
	  state-root state-root-set!
	  state-variables state-variables-set!
	  state-time state-time-set!
	  state-events state-events-set!
	  state-tweens state-tweens-set!
	  state-stage-stack state-stage-stack-set!)
  (import (chezscheme))

  (define-record-type state
    (fields
     (mutable pc)
     (mutable root)
     (mutable variables)
     (mutable time)
     (mutable events)
     (mutable tweens)
     (mutable stage-stack))
    (protocol
     (lambda (new)
       (lambda (r)
	 (new 0 r '() 0.0 '() '() '())))))

  )
