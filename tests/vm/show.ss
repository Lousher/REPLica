(library-directories "main/")
(import (chezscheme)
	(raylib ffi)
	(raylib constant)
	(vm main)
	(vm asm)
	(rpl scene)
	(rpl render)
	(rpl compile))
(define dsl
  (compile-dsl
   '((prefab show-b ()
	     (show "b.png"))
     (show "a.png")
     (scale 0.5
	    (rotate 45
	    (at 100 200 (show-b))))
      )))
(define-values (code consts)
  (assemble dsl)
  )
(define start
  (lambda ()
    (init)
    (let ([vm (make code consts)])
      (let loop ()
	(unless (WindowShouldClose)
	  (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (when (not (state-running? vm))
	      (state-running?-set! vm #t)))

	  (run vm) ; changing scene-tree silently

	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (draw (state-scene-root vm) 0.0 0.0 1.0)
	  (EndDrawing)
	  (loop))))
    (uninit)))

;(start)
