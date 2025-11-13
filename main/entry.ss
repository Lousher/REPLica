(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

; fluid variable, all used text in each chapter script
(define all-text #f)

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

(define partition-by-index
  (lambda (li)
    (let ([len (length li)])
      (let collect ([even '()] [old '()] [index 0] [rest li])
	(cond
	 [(null? rest) (values (reverse even) (reverse old))]
	 [(even? index) (collect (cons (car rest)  even)
				 old (1+ index) (cdr rest))]
	 [(odd? index) (collect even (cons (car rest) old)
				(1+ index) (cdr rest))])))))
      
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
		    (case-lambda
		      [(state) (PlaySound sound)]
		      [() (UnloadSound sound)]))))
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
(hashtable-set! *primitive-loaders* 'effect
		(lambda (vs fs)
		  (let* ([shader (LoadShader vs fs)]
			 [progress-location (GetShaderLocation shader "progress")]
			 [progress-ptr (foreign-alloc (ftype-sizeof float))]
			 [progress-fptr (make-ftype-pointer float progress-ptr)])
		    (case-lambda
		      [(frag time)
		       (lambda (passed)
			 (lambda (state)
			   (BeginShaderMode shader)
			   (let ([progress (/ passed time)])
			     (when (< progress 1.0)
			       (ftype-set! float () progress-fptr (* progress 1.0))
			       (SetShaderValue shader progress-location progress-ptr SHADER_UNIFORM_FLOAT)))
			   (frag state)
			   (EndShaderMode)))]
		      [()
		       (begin
			 (UnloadShader shader)
			 (foreign-free progress-ptr))]))))
(hashtable-set! *primitive-loaders* 'font
		(lambda (path)
		  (let* ([codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
			 [codepoints (LoadCodepoints all-text codepoints-count)]
			 [font (LoadFontEx path 50 codepoints (ftype-ref int () codepoints-count))]
			 [w (GetScreenWidth)] [h (GetScreenHeight)]
			 [subtext-y (* h 0.75)]
			 [text-vec (make-Vector2 0.0 subtext-y)]
			 [text-bg-color (make-Color 120 120 160 125)])
		    (UnloadCodepoints codepoints)
		    (foreign-free (ftype-pointer-address codepoints-count))
		    (case-lambda
		      [(str size speed)
		       (let* ([len (string-length str)]
			      [subtexts (map (lambda (sub-index) (substring str 0 sub-index)) (map 1+ (iota len)))]
			      [measured-vecs (map (lambda (subtext) (MeasureTextEx font subtext (inexact size) 0.0)) subtexts)]
			      [subtext-h (Vector2-y (car measured-vecs))]
			      [subtext-ws (map (lambda (measured-vec) (Vector2-x measured-vec)) measured-vecs)]
			      [subtext-xs (map (lambda (subtext-w) (/ (- w subtext-w) 2.0)) subtext-ws)])
			 (for-each (lambda (vec) (foreign-free (ftype-pointer-address vec))) measured-vecs)
			 (lambda (passed)
			  (lambda (state)
			    (let* ([index (exact (floor (min (/ passed speed) (1- len))))]
				   [subtext (list-ref subtexts index)]
				   [subtext-x (list-ref subtext-xs index)]
				   [subtext-w (list-ref subtext-ws index)])
			      (Vector2-x-set! text-vec subtext-x)
			      (DrawRectangle (exact (floor subtext-x)) (exact (floor subtext-y))
					     (exact (floor subtext-w)) (exact (floor subtext-h))
					     text-bg-color)
			      (DrawTextEx font subtext text-vec (inexact size) 0.0 WHITE)))))]
		      [()
		       (begin
			 (foreign-free (ftype-pointer-address text-vec))
			 (foreign-free (ftype-pointer-address text-bg-color)))]))))

(define play
  (lambda (frag)
    (let ([played #f])
      (lambda (passed)
	(lambda (state)
	  (unless played
	    (frag state)
	    (set! played #t)))))))
  
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
	   (TraceLog LOG_INFO (format-green "[Unload Overlayed Primitive]"))
	   (UnloadRenderTexture rt)
	   (foreign-free (ftype-pointer-address src-rect))
	   (foreign-free (ftype-pointer-address ori-vec)))]))))

(define static
  (lambda (frag)
    (lambda (passed)
      frag)))

(define parallel
  (lambda animators
    (lambda (passed)
      (lambda (state)
	(for-each
	 (lambda (animator)
	   ((animator passed) state))
	 animators)))))

(define sequential
  (lambda timelines
    (let-values ([(times animators) (partition-by-index timelines)])
      (let ([len (length animators)])
	(lambda (passed)
	  (let ([actived-times (filter (lambda (t) (>= passed t)) times)])
	    (let* ([applyed-total-times (append (cdr actived-times) (list passed))]
		   [applyed-diff-times (map (lambda (start end) (- end start)) actived-times applyed-total-times)]
		   [applyed-animators (list-head animators (length actived-times))])
	      (lambda (state)
		(for-each (lambda (animator diff-pass)
			    ((animator diff-pass) state))
			  applyed-animators applyed-diff-times)))))))))

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

(define extract-strings
  (lambda (scripts)
    (cond
     [(null? scripts) '()]
     [(string? scripts) (list scripts)]
     [(atom? scripts) '()]
     [(list? scripts)
      (append (extract-strings (car scripts))
	    (extract-strings (cdr scripts)))])))

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
			      (TraceLog LOG_INFO (format "Final State is ~a" s))
			      (let ([previous-part (assv ':previous s)])
				(UnloadTexture (cdr previous-part))))
			    scripts)])
	   (let* ([strings (extract-strings scripts)]
		  [available-strs (filter (lambda (str) (not (file-exists? str))) strings)])
	     (fluid-let ([all-text (apply string-append available-strs)])
	       (stroy-cps prev-state)))))
       state
       stories))
    (CloseAudioDevice)
    (CloseWindow)))
