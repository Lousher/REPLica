(define transition
  (lambda (transitionfs prev next)
    (let* ([shader (LoadShader #f transitionfs)]
	   [previous-texture-location (GetShaderLocation shader "texture1")]
	   [progress-location (GetShaderLocation shader "progress")])
	(let transiting ([progress 0.0])
	  (when prev
	    (ftype-set! float () *PROGRESS-FPTR* progress)
	    (BeginDrawing)
	    (ClearBackground BLACK)
	    (BeginShaderMode shader)
	    (SetShaderValueTexture shader previous-texture-location prev)
	    (SetShaderValue shader progress-location (ftype-pointer-address *PROGRESS-FPTR*) SHADER_UNIFORM_FLOAT)
	    (DrawTexture next 0 0 WHITE)
	    (EndShaderMode)
	    (EndDrawing)
	    (if (> progress 1.0)
		(UnloadShader shader)
		(transiting (+ progress 0.01))))))))
	   
