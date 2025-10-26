(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")
(load "parser.ss")
(load "camera.ss")

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

(hashtable-set! *layers* 'scene make-scene-layer)
(hashtable-set! *layers* 'wait make-wait-layer)
(hashtable-set! *layers* 'character make-character-layer)

(define-record-type layer
  (fields index
	  (mutable shown?)
	  (mutable loader)
	  (mutable renderer)))

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
      (lambda () (CloseAudioDevice) (CloseWindow))
      )))

(define frame->renderer
  (lambda (f)
    (assert (frame? f))
    (let* ([w (GetScreenWidth)] [h (GetScreenHeight)]
	   [rt (LoadRenderTexture w h)]
	   [src (make-Rectangle 0.0 0.0 (exact->inexact w) (exact->inexact (- h)))]
	   [origin (make-Vector2 0.0 0.0)])
      (BeginTextureMode rt)
      (for-each
       (lambda (layer)
	 (assert (layer? layer))
	 (when (layer-shown? layer)
	   (let ([resource ((layer-loader layer))])
	     ((layer-renderer layer) resource))))
       f)
      (EndTextureMode)
      (let ([screen (RenderTexture-texture rt)]
	    [camera (zoom-bedroom)])
	(lambda ()
	  (BeginMode2D (camera 1.0))
	  (DrawTextureRec screen src origin WHITE)
	  (EndMode2D)
	  )))))

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
