(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "parser.ss")
(load "shader.ss")
(load "camera.ss")
(load "transition.ss")

(define *shader-progress* (make-ftype-pointer float (foreign-alloc (ftype-sizeof float))) )
(define *resources* (make-hashtable string-hash string=?))
(define *layers* (make-hashtable symbol-hash symbol=?))
(define layer-basical?
  (lambda (layer)
    (and (layer? layer)
	 (< (layer-index layer) 1000))))
(define layer-transformer
  (lambda (l)
    (and (layer? l)
	 (> (layer-index l) 1000)
	 (< (layer-index l) 2000))))
(define layer-topping
  (lambda (l)
    (and (layer? l)
	 (> (layer-index l) 2000)
	 (< (layer-index l) 3000))))
(define layer-audio
  (lambda (l)
    (and (layer? l)
	 (> (layer-index l) 3000)
	 (< (layer-index l) 4000))))
(define layer-others
  (lambda (l)
    (and (layer? l)
	 (> (layer-index l) 4000)
	 (< (layer-index l) 5000))))

(define layer-above?
  (lambda (a b)
    (and (layer? a) (layer? b)
	 (< (layer-index a) (layer-index b)))))

(define load-resource (lambda (name res)
			(hashtable-set! *resources* name res)))
(define ref-resource (lambda (name)
		       (hashtable-ref *resources* name (lambda () (error 'ref-resource "No such resource loaded" name)))))
(define-record-type layer
  (fields index
	  (mutable shown?)
	  (mutable loader)
	  (mutable unloader)
	  (mutable renderer)
	  others))

(define make-character-layer
  (lambda (s)
    (make-layer 100 #t 
		(let ([name (cadr s)])
		  (lambda () (load-resource name (LoadTexture name))))
		(lambda ()
		  (UnloadTexture (ref-resource (cadr s)))
		  (hashtable-delete! *resources* (cadr s)))
		(lambda () (DrawTexture (ref-resource (cadr s)) 0 0 WHITE)) #f)))
(define make-scene-layer
  (lambda (s)
    (make-layer 0  #t
		(let ([name (cadr s)])
		  (lambda ()
		    (load-resource name (load-background name))))
		(lambda ()
		  (UnloadTexture (ref-resource (cadr s)))
		  (hashtable-delete! *resources* (cadr s)))
		(lambda () (DrawTexture (ref-resource (cadr s)) 0 0 WHITE)) #f)))
(define make-sound-layer
  (lambda (s)
    (make-layer 3001 #t
		(let ([name (cadr s)])
		  (lambda () (load-resource name (LoadSound name))))
		(lambda ()
		  (UnloadSound (ref-resource (cadr s)))
		  (hashtable-delete! *resources* (cadr s)))
		(lambda () (PlaySound (ref-resource (cadr s)))) #f)))
(define make-wait-layer
  (lambda (s)
    (make-layer -1 #f #f #f #f #f)))
(define make-camera-layer
  (lambda (s)
    (make-layer 1001 #t #f #f (lambda (render)
				(let ([camera ((eval (cadr s)))])
				  (lambda ()
				    (BeginMode2D (camera))
				    (render)
				    (EndMode2D)))) #f)))
(define make-effect-layer
  (lambda (s)
    (make-layer 2001 #t #f #f (lambda (render)
				(let ([shader ((eval (cadr s)))])
				  (lambda ()
				    (BeginShaderMode (shader))
				    (render)
				    (EndShaderMode)))) #f)))

(define make-transition-layer
  (lambda (s)
    (make-layer 4001 #f #f #f #f s)))

(hashtable-set! *layers* 'scene make-scene-layer)
(hashtable-set! *layers* 'wait make-wait-layer)
(hashtable-set! *layers* 'character make-character-layer)
(hashtable-set! *layers* 'camera make-camera-layer)
(hashtable-set! *layers* 'effect make-effect-layer)
(hashtable-set! *layers* 'sound make-sound-layer)
(hashtable-set! *layers* 'transition make-transition-layer)

(define frame?
  (lambda (f)
    (and (list? f)
	 (for-all layer? f))))

(define load-background
  (lambda (path)
    (assert (file-exists? path))
    (let ([img (LoadImage path)])
      (ImageResize img (GetScreenWidth) (GetScreenHeight))
      (let ([tex (LoadTextureFromImage img)])
	(UnloadImage img)
	tex))))

(define with-window
  (lambda (thunk)
    (dynamic-wind
      (lambda ()
	(SetConfigFlags (logor FLAG_WINDOW_MAXIMIZED
			       FLAG_WINDOW_MINIMIZED))
	(SetTargetFPS 60)
	(InitWindow (GetScreenWidth) (GetScreenHeight) "Test")
	(InitAudioDevice))
      (lambda () (thunk))
      (lambda ()
	(CloseAudioDevice)
	(CloseWindow)
	(foreign-free (ftype-pointer-address *shader-progress*)))
      )))

(define script->layer
  (lambda (s)
    (if (hashtable-contains? *layers* (car s))
	((hashtable-ref *layers* (car s) 'NULL) s)
	(error 'script->layer "Not a valid script"))))

(define directive->frame
  (lambda (directive)
    (assert (for-all script? directive))
    (map script->layer directive)))

(define resources-lifecycle
  (lambda (frames)
    (assert (for-all frame? frames))
    (let ([fields (lambda (ref) (apply append (map (lambda (f) (map ref f)) frames)))])
      (values
       (lambda () (for-each (lambda (x) (when x (x))) (fields layer-loader)))
       (lambda () (for-each (lambda (x) (when x (x))) (fields layer-unloader)))))))

(define frame-lifecycle
  (lambda (f)
    (assert (frame? f))
    (let* ([w (GetScreenWidth)] [h (GetScreenHeight)]
	   [rt (LoadRenderTexture w h)]
	   [src (make-Rectangle 0.0 0.0 (exact->inexact w) (exact->inexact (- h)))]
	   [origin (make-Vector2 0.0 0.0)])
      (let*-values ([(basics other-than-basics) (partition layer-basical? f)]
		    [(transformers other-than-transformers) (partition layer-transformer other-than-basics)]
		    [(toppings other-than-toppings) (partition layer-topping other-than-transformers)]
		    [(audios others) (partition layer-audio other-than-toppings)])
	(BeginTextureMode rt)
	(for-each
	 (lambda (layer)
	   (assert (layer? layer))
	   (when (layer-shown? layer)
	     ((layer-renderer layer))))
	 (sort layer-above? basics))
	(EndTextureMode)
	(let ([screen (RenderTexture-texture rt)])
	  (let ([transformed-renderer (fold-left
				       (lambda (prev next)
					 (if (layer-shown? next)
					     ((layer-renderer next) prev)
					     prev))
				       (lambda () (DrawTextureRec screen src origin WHITE))
				       (sort layer-above? transformers))])
	    (let* ([final-rt (LoadRenderTexture w h)]
		   [final-screen (RenderTexture-texture final-rt)]
		   [final-renderer (fold-left
				    (lambda (prev next)
				      (if (layer-shown? next)
					  ((layer-renderer next) prev)
					  prev))
				    (lambda () (DrawTextureRec final-screen src origin WHITE))
				    (sort layer-above? toppings))])
	      (values
	       (lambda ()
		 (BeginTextureMode final-rt)
		 (transformed-renderer)
		 (EndTextureMode)
		 (final-renderer)
		 final-screen)
	       (lambda ()
		 (for-each (lambda (l)
			     (when (layer-shown? l)
			       ((layer-renderer l))))
			   (sort layer-above? audios)))
	       (lambda ()
		   (UnloadRenderTexture rt)
		   (UnloadRenderTexture final-rt)
		   (foreign-free (ftype-pointer-address src))
		   (foreign-free (ftype-pointer-address origin)))
	       (lambda ()
		 (sort layer-above? others))))))))))

(define load-texture-from-screeen
  (lambda ()
    (let* ([img (LoadImageFromScreen)]
	   [tex (LoadTextureFromImage img)])
      (UnloadImage img)
      tex)))
(define load-texture-from-render-texture-texture
  (lambda (texture)
    (let ([img (LoadImageFromTexture texture)])
      (ImageFlipVertical img)
      (let ([tex (LoadTextureFromImage img)])
	(UnloadImage img)
	tex))))

(define replica
  (lambda (rpl-file)
    (let* ([directives (call-with-input-file rpl-file read-directives)]
	   [frames (map directive->frame directives)])
      (let-values ([(preload-resources unload-resources) (resources-lifecycle frames)])
	(with-window
	 (lambda ()
	   (dynamic-wind
	     (lambda ()
	       (preload-resources))
	     (lambda ()
	       (let interacting ([rest frames] [previous #f])
		 (let-values ([(renderer sounder cleanup others) (frame-lifecycle (car rest))])
		   (let ([next (load-texture-from-render-texture-texture (renderer))])
		     (let ([trans (find (lambda (l) (and (layer-others l)
						(eqv? 'transition (car (layer-others l))))) (others))])
		       (if trans
			 (transition (cadr (layer-others trans)) previous next)
			 (transition "../assets/glsl/fade.transition.fs" previous next))))
		   (sounder)
		   (let rendering ()
		     (BeginDrawing)
		     (ClearBackground BLACK)
		     (renderer)
		     (EndDrawing)
		     (cond
		      [(WindowShouldClose) (void)]
		      [(IsMouseButtonPressed MOUSE_BUTTON_LEFT)
		       (begin
			 (cleanup)
			 (interacting (cdr rest) (load-texture-from-screeen)))]
		      [else (rendering)])))))
	     (lambda () (unload-resources))
	     )))))))
