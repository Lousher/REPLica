(library (replica)
  (export replica *story*)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (tool)
	  (state))

  (define *story* (make-parameter #f))
      
  (define replica
    (lambda (entry)
      (InitWindow (GetScreenWidth) (GetScreenHeight) "TEST")
      (InitAudioDevice)
      (let storying ([current-story entry]
		     [current-state (state-init)])
	(load (format "~a.so" current-story))
	(let ([story-f (*story*)])
	  (let-values ([(sig new-state) (story-f current-state)])
	    (TraceLog LOG_INFO (format-green "State is ~a, Sig is ~a" new-state sig)))))
      (CloseAudioDevice)
      (CloseWindow)
      ))
  )
