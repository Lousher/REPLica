(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "parser.ss")
(load "shader.ss")
(load "camera.ss")

(define *shader-progress* (make-ftype-pointer float (foreign-alloc (ftype-sizeof float))) )
(define-record-type layer
  (fields index
	  (mutable shown?)
	  (mutable loader)
	  (mutable renderer)))
(define *layers* (make-hashtable symbol-hash symbol=?))
(define make-character-layer
  (lambda (s)
    (make-layer 100 #t
		(lambda () (LoadTexture (cadr s)))
		(lambda (t) (DrawTexture t 0 0 WHITE)))))
(define make-scene-layer
  (lambda (s)
    (make-layer 0 #t
		(lambda () (load-background (cadr s)))
		(lambda (t) (DrawTexture t 0 0 WHITE)))))
(define make-wait-layer
  (lambda (s)
    (make-layer -1 #f #f #f)))
(define make-camera-layer
  (lambda (s)
    (make-layer 1001 #t #f (lambda (render)
			     (let ([camera ((eval (cadr s)))])
			       (lambda ()
				 (BeginMode2D (camera))
				 (render)
				 (EndMode2D)))))))
(define make-effect-layer
  (lambda (s)
    (make-layer 2001 #t #f (lambda (render)
			     (let ([shader ((eval (cadr s)))])
			       (lambda ()
				 (BeginShaderMode (shader))
				 (render)
				 (EndShaderMode)))))))
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
	 (> (layer-index l) 3000))))
(define layer-above?
  (lambda (a b)
    (and (layer? a) (layer? b)
	 (< (layer-index a) (layer-index b)))))
(hashtable-set! *layers* 'scene make-scene-layer)
(hashtable-set! *layers* 'wait make-wait-layer)
(hashtable-set! *layers* 'character make-character-layer)
(hashtable-set! *layers* 'camera make-camera-layer)
(hashtable-set! *layers* 'effect make-effect-layer)

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
      (lambda () (CloseAudioDevice) (CloseWindow) (foreign-free (ftype-pointer-address *shader-progress*)))
      )))

(define frame->renderer
  (lambda (f)
    (assert (frame? f))
    (let* ([w (GetScreenWidth)] [h (GetScreenHeight)]
	   [rt (LoadRenderTexture w h)]
	   [src (make-Rectangle 0.0 0.0 (exact->inexact w) (exact->inexact (- h)))]
	   [origin (make-Vector2 0.0 0.0)])
      (let*-values ([(basics specials) (partition layer-basical? f)]
		    [(transformers toppings) (partition layer-transformer specials)])
	(BeginTextureMode rt)
	(for-each
	 (lambda (layer)
	   (assert (layer? layer))
	   (when (layer-shown? layer)
	     (let ([resource ((layer-loader layer))])
	       ((layer-renderer layer) resource))))
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
	      (lambda ()
		(BeginTextureMode final-rt)
		(transformed-renderer)
		(EndTextureMode)
		(final-renderer)))))))))

(define script->layer
  (lambda (s)
    (if (hashtable-contains? *layers* (car s))
	((hashtable-ref *layers* (car s) 'NULL) s)
	(error 'script->layer "Not a valid script"))))

(define directive->frame
  (lambda (directive)
    (assert (for-all script? directive))
    (map script->layer directive)))

(define replica
  (lambda (rpl-file)
    (let* ([directives (call-with-input-file rpl-file read-directives)]
	   [frames (map directive->frame directives)])
      (with-window
       (lambda ()
	 (let ([renderer (frame->renderer (car frames))])
	   (let rendering ()
	     (BeginDrawing)
	     (renderer)
	     (EndDrawing)
	     (unless (WindowShouldClose)
	       (rendering)))))))))
