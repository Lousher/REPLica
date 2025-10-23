(define mask #f)
(define wakeup #f)

(define load-postive-shader
  (lambda (file)
    (let* ([progress 0.0]
	   [shader (LoadShader #f file)]
	   [progress-ptr (foreign-alloc (ftype-sizeof float))]
	   [progress-loc (GetShaderLocation shader "progress")]
	   [progress-fptr (make-ftype-pointer float progress-ptr)])
	(lambda (x)
	  (when (<= progress 1.0)
	    (set! progress (+ progress 0.02)))
	  (ftype-set! float () progress-fptr (min progress 1.0))
	  (SetShaderValue shader progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	  shader))))
(define load-negative-shader
  (lambda (file)
    (let* ([progress 1.0]
	   [shader (LoadShader #f file)]
	   [progress-ptr (foreign-alloc (ftype-sizeof float))]
	   [progress-loc (GetShaderLocation shader "progress")]
	   [progress-fptr (make-ftype-pointer float progress-ptr)])
	(lambda (x)
	  (when (>= progress 0.0)
	    (set! progress (- progress 0.02)))
	  (ftype-set! float () progress-fptr (min progress 1.0))
	  (SetShaderValue shader progress-loc progress-ptr SHADER_UNIFORM_FLOAT)
	  shader))))

(define load-shader
  (lambda (file)
    (lambda (start)
      (if (zero? start)
	  (load-negative-shader file)
	  (load-postive-shader file)
	  ))))

(define init-shaders
  (lambda ()
    (set! mask (load-shader "../assets/glsl/mask.fs"))
    (set! wakeup (load-shader "../assets/glsl/wakeup.fs"))))

