(library (replica)
  (export replica *actions*)
  (import (chezscheme)
	  (raylib ffi))

  (define *actions* (make-parameter #f))

  (define state-init (lambda () `((:global . ((:window . ((:x . 0) (:y . 0) (:width . ,(GetScreenWidth)) (:height . ,(GetScreenHeight)))))) (:local . ()))))
  
  (define replica
    (lambda (entry)
      (InitWindow (GetScreenWidth) (GetScreenHeight) "Test")
      (InitAudioDevice)
      (SetTargetFPS 60)
      (let storying ([current-story entry]
		     [current-state (state-init)])
	(load current-story)
	(let* ([steps (*actions*)]
	       [len (vector-length steps)])
	  (let stepper ([index 0])
	    (unless (>= index len)
	      ((vector-ref steps index) current-state)
	      (stepper (+ index 1))))))
      (CloseAudioDevice)
      (CloseWindow)))
  )
