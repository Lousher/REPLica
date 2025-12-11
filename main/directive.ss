(library (directive)
  (export make-animation static background jump above beside play parallel locate duration stop trigger)
  (import (chezscheme)
	  (state)
	  (loader)
	  (raylib ffi)
	  (raylib constant))

  (define state-save-previous
    (lambda (s)
      (let ([prev-img (LoadImageFromScreen)])
	(ImageFlipVertical prev-img)
	(let ([prev-tex (LoadTextureFromImage prev-img)])
	  (UnloadImage prev-img)
	  (resource-guardian prev-tex)
	  (state-previous-set! s prev-tex)
	  s))))

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
	    (values `(next) (state-save-previous s))]
	   [else (animating (state-time-pass s (GetFrameTime)))])))))
  
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
  
  (define background
    (lambda (res)
      (let ([src #f] [dest #f]
	    [origin (make-Vector2 0.0 0.0)])
	(resource-guardian origin)
	(lambda (s)
	  (unless dest
	    (set! dest (window->Rectangle (state-window s))))
	  (let ([current-status #f] [current-data #f])
	    (with-mutex (resource-lock res)
	      (set! current-status (resource-status res))
	      (when (or (eqv? current-status 'ram-ready)
			(eqv? current-status 'gpu-ready))
		(set! current-data (resource-data res))))
	    (case current-status
	      [(loading)
	       (DrawText "Loading ..." 0 0 20 WHITE)]
	      [(ram-ready)
	       (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...\n")
	       (ImageResize current-data (GetScreenWidth) (GetScreenHeight))
	       (let ([tex (LoadTextureFromImage current-data)])
		 (resource-guardian tex)
		 (with-mutex (resource-lock res)
		   (resource-data-set! res tex)
		   (resource-status-set! res 'gpu-ready)))]
	      [(gpu-ready)
	       (unless src
		 (set! src (texture->Rectangle current-data)))
	       (DrawTexturePro current-data src dest origin 0.0 WHITE)])
	    )))))

  (define static
    (lambda (res)
      (lambda (s)
	(let ([current-status #f] [current-data #f] [win (state-window s)])
	  (with-mutex (resource-lock res)
	    (set! current-status (resource-status res))
	    (when (or (eqv? current-status 'ram-ready)
		      (eqv? current-status 'gpu-ready))
	      (set! current-data (resource-data res))))
	    (case current-status
	      [(loading)
	       (DrawText "Loading ..." 0 0 20 WHITE)]
	      [(ram-ready)
	       (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...\n")
	       (let ([tex (LoadTextureFromImage current-data)])
		 (resource-guardian tex)
		 (with-mutex (resource-lock res)
		   (resource-data-set! res tex)
		   (resource-status-set! res 'gpu-ready)))]
	      [(gpu-ready)
	       (DrawTexture current-data
			    (round (exact (window-x win)))
			    (round (exact (window-y win))) WHITE)])))))

  (define play
    (lambda (so)
      (let ([played #f])
	(lambda (s)
	  (unless played
	    (PlaySound so)
	    (set! played #t))))))

  (define stop
    (lambda (so)
      (let ([stopped #f])
	(lambda (s)
	  (unless stopped
	    (StopSound so)
	    (set! stopped #t))))))
	

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
	      (set! s-a (state-copy s))
	      (window-height-set! (state-window s-a) h-a)
	      (set! s-b (state-copy s))
	      (window-y-set! (state-window s-b) (+ y h-a))
	      (window-height-set! (state-window s-b) (- h h-a))))
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
	      (set! s-a (state-copy s))
	      (window-width-set! (state-window s-a) w-a)
	      (set! s-b (state-copy s))
	      (window-x-set! (state-window s-b) (+ x w-a))
	      (window-width-set! (state-window s-b) (- w w-a))))
	  (ani-a s-a)
	  (ani-b s-b)))))
  
  (define parallel
    (lambda anis
      (lambda (s)
	(for-each (lambda (ani) (ani s)) anis))))

  (define locate
    (lambda (ani x-factor y-factor)
      (lambda (s)
	(let* ([s-located (state-copy s)]
	       [win-located (state-window s-located)])
	  (window-x-set! win-located (* x-factor (window-width win-located)))
	  (window-y-set! win-located (* y-factor (window-height win-located)))
	  (ani s-located)))))

  (define duration
    (lambda (ani t)
      (let ([started #f])
	(lambda (s)
	  (unless started
	    (set! started (state-time s)))
	  (when (< (- (state-time s) started) t)
	    (ani s))
	  ))))

  (define trigger
    (lambda (ani t)
      (let ([started #f])
	(lambda (s)
	  (unless started
	    (set! started (state-time s)))
	  (unless (< (- (state-time s) started) t)
	    (ani s))))))

  )

