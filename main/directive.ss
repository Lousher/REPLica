(library (directive)
  (export static)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant))

  (define make-animation
    (lambda (animator)
      (lambda (state)
	(let animating ([s state])
	  (BeginDrawing)
	  (animator state)
	  (EndDrawing)
	  (unless (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (animating s))))))

  (define static
    (lambda (tex)
      (lambda (state)
	(let animating ([s state])
	  (BeginDrawing)
	  (DrawTexture tex 0 0 WHITE)
	  (EndDrawing)
	  (unless (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (animating s))))))
  
  )
