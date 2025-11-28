(library (animation)
  (export make-animation)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant))
  
  (define make-animation
    (lambda (animator end?)
      (lambda (state)
	(let animating ([s state])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  
	  (EndDrawing)
      ))
  )
