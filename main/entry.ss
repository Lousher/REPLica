(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

(define reads
  (lambda (port)
    (let ([content (read port)])
      (if (eof-object? content)
	  '()
	  (cons content (reads port))))))
(define format-green
  (lambda (fmt-str . rest)
    (apply format (format "\033[0;32m~a\033[0m" fmt-str) rest)))
(define load-primitive
  (lambda (type args)
    (let ([loader (hashtable-ref *primitive-loaders* type (lambda () (error 'load-primitive "No Loader Definition Found" type)))])
      (apply loader args))))
(define load-texture-from-screen
  (lambda ()
    (let ([screen-img (LoadImageFromScreen)])
      (ImageResize screen-img (GetScreenWidth) (GetScreenHeight))
      (let ([screen-tex (LoadTextureFromImage screen-img)])
	(UnloadImage screen-img)
	screen-tex))))
      
(define *primitive-loaders* (make-hashtable symbol-hash symbol=?))
(hashtable-set! *primitive-loaders* 'background
		(lambda (path)
		  (let ([img (LoadImage path)])
		    (ImageResize img (GetScreenWidth) (GetScreenHeight))
		    (let ([tex (LoadTextureFromImage img)])
		      (UnloadImage img)
		      (case-lambda
			[(state) (DrawTexture tex 0 0 WHITE)]
			[() (UnloadTexture tex)])))))
(hashtable-set! *primitive-loaders* 'character
		(lambda (path)
		  (let ([tex (LoadTexture path)])
		    (case-lambda
		      [(state) (DrawTexture tex 0 0 WHITE)]
		      [() (UnloadTexture tex)]))))
(hashtable-set! *primitive-loaders* 'sound
		(lambda (path)
		  (let ([sound (LoadSound path)])
		    (let ([played #f])
		      (case-lambda
			[(state)
			 (unless played
			   (PlaySound sound)
			   (set! played #t))]
			[() (UnloadSound sound)])))))
(hashtable-set! *primitive-loaders* 'transition
		(lambda (vs fs)
		  (let* ([shader (LoadShader vs fs)]
			 [texture1-location (GetShaderLocation shader "texture1")]
			 [progress-location (GetShaderLocation shader "progress")]
			 [progress-ptr (foreign-alloc (ftype-sizeof float))]
			 [progress-fptr (make-ftype-pointer float progress-ptr)]
			 [previous-screen #f])
		    (case-lambda
		      [(frag time)
		       (lambda (passed)
			 (lambda (state)
			   (unless previous-screen
			     (let ([previous-part (assv ':previous state)])
			       (set! previous-screen (cdr previous-part))))
			   (BeginShaderMode shader)
			   (let ([progress (/ passed time)])
			     (when (< progress 1.0)
			       (ftype-set! float () progress-fptr (* progress 1.0))
			       (SetShaderValueTexture shader texture1-location previous-screen)
			       (SetShaderValue shader progress-location progress-ptr SHADER_UNIFORM_FLOAT)))
			   (frag state)
			   (EndShaderMode)))]
		      [()
		       (begin
			 (UnloadShader shader)
			 (foreign-free progress-ptr))]))))

(define overlay
  (lambda frags
    (let* ([w (GetScreenWidth)] [h (GetScreenHeight)]
	   [rt (LoadRenderTexture w h)]
	   [src-rect (make-Rectangle 0.0 0.0 (* 1.0 w) (* -1.0 h))]
	   [ori-vec (make-Vector2 0.0 0.0)]
	   [tex (RenderTexture-texture rt)]
	   [draw-rt (lambda (s)
		      (BeginTextureMode rt)
		      (ClearBackground BLACK)
		      (for-each (lambda (frag) (frag s)) frags)
		      (EndTextureMode))])
      (case-lambda
	[(state)
	 (let ([cached #f])
	   (unless cached
	     (draw-rt state)
	     (set! cached #t))
	   (DrawTextureRec tex src-rect ori-vec WHITE))]
	[()
	 (begin
	   (UnloadRenderTexture rt)
	   (foreign-free (ftype-pointer-address src-rect))
	   (foreign-free (ftype-pointer-address ori-vec)))]))))

(define static
  (lambda (frag)
    (lambda (passed)
      frag)))

(define script-preload?
  (lambda (script)
    (and (list? script)
	 (eqv? 'preload (car script)))))
(define-syntax preload
  (syntax-rules ()
    [(_ (type name . args) ...)
     (begin
       (define-top-level-value 'name (load-primitive 'type 'args)) ...
       (TraceLog LOG_INFO (format-green "[~a Type Primitive ~a Definied]" 'type 'name)) ...
       (lambda (state next)
	 (dynamic-wind
	   (lambda ()
	     (TraceLog LOG_INFO (format-green "Preload ~a successfully" (datum (name ...)))))
	   (lambda ()
	     (next state))
	   (lambda ()
	     (name) ...
	     (TraceLog LOG_INFO (format-green "[~a Type Primitive ~a Unload]" 'type 'name)) ...))))]))

(define make-directive
  (lambda (animator end?)
    (lambda (state next)
      (let animating ([passed 0.0])
	(BeginDrawing)
	(ClearBackground BLACK)
	((animator passed) state)
	(EndDrawing)
	(cond
	 [(WindowShouldClose) (void)]
	 [(end? state)
	  (let* ([previous-part (assv ':previous state)]
		 [previous-texture (cdr previous-part)])
	    (when previous-texture
	      (UnloadTexture previous-texture))
	    (set-cdr! previous-part (load-texture-from-screen))
	    (next state))]
	 [else
	  (animating (+ passed (GetFrameTime)))])))))
(define normal-directive
  (lambda (animator)
    (make-directive
     animator
     (lambda (s) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))))

(define replica
  (lambda (stories)
    (InitWindow (GetScreenWidth) (GetScreenHeight) "TEST")
    (InitAudioDevice)
    (let ([state '((:previous . #f))])
      (fold-left
       (lambda (prev-state remaining-story)
	 (let* ([scripts (call-with-input-file remaining-story reads)]
		[stroy-cps (fold-right
			    (lambda (script acc-k)
			      (lambda (state)
				(let* ([directive (if (script-preload? script)
						      (eval script)
						      (normal-directive (eval script)))])
				  (directive state acc-k))))
			    (lambda (s) 
			      (TraceLog LOG_INFO (format "Final State is ~a" s)))
			    scripts)])
	   (stroy-cps prev-state)))
       state
       stories))
    (CloseAudioDevice)
    (CloseWindow)))
