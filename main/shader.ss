(define mask
  (lambda ()
    (ftype-set! float () *shader-progress* 0.0)
    (let* ([progress 0.0]
	   [shader (LoadShader #f "../assets/glsl/mask.effect.fs")]
	   [progress-ptr (ftype-pointer-address *shader-progress*)]
	   [progress-loc (GetShaderLocation shader "progress")])
      (lambda ()
	(when (<= progress 1.0)
	  (set! progress (+ progress 0.02)))
	(ftype-set! float () *shader-progress* (min progress 1.0))
	(SetShaderValue shader progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	shader))))
