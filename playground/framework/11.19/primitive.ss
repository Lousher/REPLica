;special element
(load "phone.ss")

(define *primitive-loaders* (make-hashtable symbol-hash symbol=?))
(define load-primitive
  (lambda (type args)
    (let ([loader (hashtable-ref *primitive-loaders* type (lambda () (error 'load-primitive "No Loader Definition Found" type)))])
      (apply loader args))))
(hashtable-set! *primitive-loaders* 'phone
		phone-loader)
(hashtable-set! *primitive-loaders* 'background
		(lambda (path)
		  (let ([img (LoadImage path)])
		    (ImageResize img (GetScreenWidth) (GetScreenHeight))
		    (let ([tex (LoadTextureFromImage img)])
		      (UnloadImage img)
		      (case-lambda
			[(state) (DrawTexture tex 0 0 WHITE)]
			[() (UnloadTexture tex)])))))
(hashtable-set! *primitive-loaders* 'picture
		(lambda (path)
		  (let* ([tex (LoadTexture path)]
			 [tex-w (Texture-width tex)]
			 [tex-h (Texture-height tex)]
			 [w (GetScreenWidth)] [h (GetScreenHeight)]
			 [x (/ (- w tex-w) 2.0)]
			 [y (/ (- h tex-h) 2.0)]
			 [pos-vec (make-Vector2 x y)])
		    (case-lambda
		      [(state)
		       (DrawTextureV tex pos-vec WHITE)
		       ]
		      [(x! y!)
		       (begin
			 (Vector2-x-set! pos-vec (x! x))
			 (Vector2-y-set! pos-vec (y! y)))]
		      [()
		       (begin
			 (UnloadTexture tex)
			 (foreign-free (ftype-pointer-address pos-vec)))]))))
(hashtable-set! *primitive-loaders* 'sound
		(lambda (path)
		  (let ([sound (LoadSound path)])
		    (case-lambda
		      [(state) (PlaySound sound)]
		      [(op . args)
		       (case op
			 [(stop) (StopSound sound)]
			 [(pan) (apply SetSoundPan sound args)]
			 [(volume) (apply SetSoundVolume sound args)]
			 [(pitch) (apply SetSoundPitch sound args)])]
		      [() (UnloadSound sound)]))))
(hashtable-set! *primitive-loaders* 'transition
		(lambda (vs fs)
		  (let* ([shader (LoadShader vs fs)]
			 [texture1-location (GetShaderLocation shader "texture1")]
			 [progress-location (GetShaderLocation shader "progress")]
			 [progress-ptr (foreign-alloc (ftype-sizeof float))]
			 [progress-fptr (make-ftype-pointer float progress-ptr)]
			 [w (GetScreenWidth)] [h (GetScreenHeight)]
			 [rt (LoadRenderTexture w h)] [rt-tex (RenderTexture-texture rt)]
			 [src-rect (make-Rectangle 0.0 0.0 (* 1.0 w) (* -1.0 h))]
			 [ori-vec (make-Vector2 0.0 0.0)]
			 [previous-screen #f])
		    (case-lambda
		      [(animator time)
		       (lambda (passed)
			 (lambda (state)
			   (unless previous-screen
			     (let ([previous-part (assv ':previous state)])
			       (set! previous-screen (cdr previous-part))))
			   (BeginTextureMode rt)
			   (ClearBackground BLACK)
			   ((animator passed) state)
			   (EndTextureMode)
			   (BeginShaderMode shader)
			   (let ([progress (/ passed time)])
			     (when (< progress 1.0)
			       (ftype-set! float () progress-fptr (* progress 1.0))
			       (SetShaderValueTexture shader texture1-location previous-screen)
			       (SetShaderValue shader progress-location progress-ptr SHADER_UNIFORM_FLOAT)))
			   (DrawTextureRec rt-tex src-rect ori-vec WHITE)
			   (EndShaderMode)))]
		      [()
		       (begin
			 (UnloadShader shader)
			 (UnloadRenderTexture rt)
			 (foreign-free (ftype-pointer-address src-rect))
			 (foreign-free (ftype-pointer-address ori-vec))
			 (foreign-free progress-ptr))]))))
(hashtable-set! *primitive-loaders* 'effect
		(lambda (vs fs)
		  (let* ([shader (LoadShader vs fs)]
			 [progress-location (GetShaderLocation shader "progress")]
			 [progress-ptr (foreign-alloc (ftype-sizeof float))]
			 [progress-fptr (make-ftype-pointer float progress-ptr)]
			 [w (GetScreenWidth)] [h (GetScreenHeight)]
			 [rt (LoadRenderTexture w h)] [rt-tex (RenderTexture-texture rt)]
			 [src-rect (make-Rectangle 0.0 0.0 (* 1.0 w) (* -1.0 h))]
			 [ori-vec (make-Vector2 0.0 0.0)])
		    (case-lambda
		      [(animator time)
		       (lambda (passed)
			 (lambda (state)
			   (BeginTextureMode rt)
			   (ClearBackground BLACK)
			   ((animator passed) state)
			   (EndTextureMode)
			   (BeginShaderMode shader)
			   (let ([progress (/ passed time)])
			     (when (< progress 1.0)
			       (ftype-set! float () progress-fptr (* progress 1.0))
			       (SetShaderValue shader progress-location progress-ptr SHADER_UNIFORM_FLOAT)))
			   (DrawTextureRec rt-tex src-rect ori-vec WHITE)
			   (EndShaderMode)))]
		      [()
		       (begin
			 (UnloadShader shader)
			 (UnloadRenderTexture rt)
			 (foreign-free (ftype-pointer-address src-rect))
			 (foreign-free (ftype-pointer-address ori-vec))
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
		    (let ([text-fn (with-defaults
				    (:size 50 :speed 0.05 :color WHITE)
				    (lambda (str)
				      (let* ([len (string-length str)]
					     [subtexts (map (lambda (sub-index) (substring str 0 sub-index)) (map 1+ (iota len)))]
					     [measured-vecs (map (lambda (subtext) (MeasureTextEx font subtext (inexact :size) 0.0)) subtexts)]
					     [subtext-h (Vector2-y (car measured-vecs))]
					     [subtext-ws (map (lambda (measured-vec) (Vector2-x measured-vec)) measured-vecs)]
					     [subtext-xs (map (lambda (subtext-w) (/ (- w subtext-w) 2.0)) subtext-ws)])
					(for-each (lambda (vec) (foreign-free (ftype-pointer-address vec))) measured-vecs)
					(lambda (passed)
					  (lambda (state)
					    (let* ([index (exact (floor (min (/ passed :speed) (1- len))))]
						   [subtext (list-ref subtexts index)]
						   [subtext-x (list-ref subtext-xs index)]
						   [subtext-w (list-ref subtext-ws index)])
					      (Vector2-x-set! text-vec subtext-x)
					      (DrawRectangle (exact (floor subtext-x)) (exact (floor subtext-y))
							     (exact (floor subtext-w)) (exact (floor subtext-h))
							     text-bg-color)
					      (DrawTextEx font subtext text-vec (inexact :size) 0.0 :color)))))))])
		    (case-lambda
		      [()
		       (begin
			 (foreign-free (ftype-pointer-address text-vec))
			 (foreign-free (ftype-pointer-address text-bg-color)))]
		      [args (apply text-fn args)])))))

(hashtable-set! *primitive-loaders* 'camera
		(let ([camera (init-Camera2D)])
		  (with-defaults
		   (:offset (lambda (p) `(0.0 . 0.0))
		    :target (lambda (p) `(0.0 . 0.0))
		    :zoom (lambda (p) 1.0)
		    :rotation (lambda (p) 0.0))
		   (lambda ()
		     (case-lambda
		       [(animator)
			(lambda (passed)
			  (Camera2D-offset-set! camera (:offset passed))
			  (Camera2D-target-set! camera (:target passed))
			  (Camera2D-zoom-set! camera (:zoom passed))
			  (Camera2D-rotation-set! camera (:rotation passed))
			  (lambda (state)
			    (BeginMode2D camera)
			    ((animator passed) state)
			    (EndMode2D)))]
		       [() (void)])))))
