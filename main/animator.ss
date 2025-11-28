(library (animator)
  (export directing static parallel)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (state)
	  (monad)
	  (loader))

  (define directive->action
    (lambda (directive)
      (lambda (state)
	(let animating ([s state])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (directive s)
	  (EndDrawing)
	  (cond
	   [(WindowShouldClose) (values 'done s)]
	   [(IsMouseButtonPressed MOUSE_BUTTON_LEFT) (values 'next s)]
	   [else (animating (state-time-pass s (GetFrameTime)))])))))

  (define directing
    (lambda directives
      (let ([actions (map directive->action directives)])
	(apply sequence actions))))

  (define static
    (lambda (res)
      (lambda (state)
	(DrawTexture (visual-resource res) 0 0 (visual-color res)))))

  (define parallel
    (lambda animators
      (lambda (state)
	(for-each (lambda (ani) (ani state)) animators))))

  )
