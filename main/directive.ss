(library (directive)
  (export make-animation static jump above beside)
  (import (chezscheme)
	  (state)
	  (loader)
	  (raylib ffi)
	  (raylib constant))

  (define make-animation
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

  (define texture->Rectangle
    (lambda (tex)
      (let ([rect (make-Rectangle 0.0 0.0 (inexact (Texture-width tex)) (inexact (Texture-height tex)))])
	(resource-guardian rect)
	rect)))

  (define window->Rectangle
    (lambda (win)
      (let ([rect (make-Rectangle (window-x win) (window-y win) (window-width win) (window-height win))])
	(resource-guardian rect)
	rect)))
  
  (define static
    (lambda (tex)
      (let ([src (texture->Rectangle tex)]
	    [origin (make-Vector2 0.0 0.0)]
	    [dest #f])
	(resource-guardian origin)
	(lambda (s)
	  (unless dest
	    (set! dest (window->Rectangle (state-window s))))
	  (DrawTexturePro tex src dest origin 0.0 WHITE)))))

  (define above
    (lambda (ani-a ani-b factor)
      (let ([s-a #f] [s-b #f])
	(lambda (s)
	  (unless (or s-a s-b)
	    (let* ([win (state-window s)]
		   [x (window-x win)]
		   [y (window-y win)]
		   [w (window-width win)]
		   [h (window-height win)]
		   [h-a (* h factor)])
	      (set! s-a (make-state (make-window x y w h-a)))
	      (set! s-b (make-state (make-window x (+ y h-a) w (- h h-a))))))
	  (ani-a s-a)
	  (ani-b s-b)))))

  (define beside
    (lambda (ani-a ani-b factor)
      (let ([s-a #f] [s-b #f])
	(lambda (s)
	  (unless (or s-a s-b)
	    (let* ([win (state-window s)]
		   [x (window-x win)]
		   [y (window-y win)]
		   [w (window-width win)]
		   [h (window-height win)]
		   [w-a (* w factor)])
	      (set! s-a (make-state (make-window x y w-a h)))
	      (set! s-b (make-state (make-window (+ x w-a) y (- w w-a) h)))))
	  (ani-a s-a)
	  (ani-b s-b)))))

  )

