(library (replica)
  (export replica *actions*)
  (import (chezscheme)
	  (state)
	  (loader)
	  (raylib ffi)
	  (raylib constant))

  (define *actions* (make-parameter #f))

  (define state-init
    (lambda ()
      (make-state (make-window 0.0 0.0 (inexact (GetScreenWidth)) (inexact (GetScreenHeight))))))

  (define replica-collect
    (lambda ()
      (collect 4)
      (resource-collect)
      (ffi-collect)))
  
  (define replica
    (lambda (entry)
      (InitWindow (GetScreenWidth) (GetScreenHeight) "Test")
      (InitAudioDevice)
      (SetTargetFPS 60)
      (call/cc
       (lambda (exit)
	 (let storying ([current-story entry]
			[story-state (state-init)])
	   (load current-story)
	   (let stepper ([rest (*actions*)] [step-state story-state])
	     (*actions* #f)
	     (let-values ([(sig new-state) ((car rest) step-state)])
	       (TraceLog LOG_INFO (format "Signal is ~a" sig))
	       (case (car sig)
		 [(exit)
		  (TraceLog LOG_INFO (format "State is ~a" new-state))
		  (exit)]
		 [(jump)
		  (replica-collect)
		  (storying (cadr sig) new-state)]
		 [else (stepper (cdr rest) new-state)]
		 ))))))
      (CloseAudioDevice)
      (CloseWindow)))
  )
