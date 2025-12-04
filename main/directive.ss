(library (directive)
  (export static jump)
  (import (chezscheme)
	  (loader)
	  (raylib ffi)
	  (raylib constant))

  (define make-action
    (lambda (animator)
      (lambda (state)
	(let animating ([s state])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (animator s)
	  (EndDrawing)
	  (cond
	   [(WindowShouldClose)
	    (values `(exit) s)]
	   [(IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (values `(next) s)]
	   [else (animating s)])))))
  
  (define jump
    (lambda (next)
      (lambda (state)
	(values `(jump ,next) state))))

  (define static
    (lambda (tex)
      (make-action (lambda (s) (DrawTexture tex 0 0 WHITE)))))

    )
