(library (core animator)
  (export
   picture->animator
   static spin shake
   crossfade overlay
   appear disappear  dissolve
   )
  (import
   (ffi raylib binding)
   (core frame)
   (core type)
   (only (core picture) *TINT*)
   (chezscheme)
   (design color)
   (core picture)
   )

					; animator is a procedure, inputs process(normally [0-1]), output a picture,
  (define picture->animator
    (lambda (pic)
      (lambda (progress) pic)))
  
  (define static
    (lambda (ani p)
      (let ([pic (ani p)])
	(lambda (progress)
	  pic))))

  (define spin
    (lambda (ani angle)
      (lambda (progress)
	(rotate (ani progress)
		(lambda (r) (+ r (* progress angle)))))))

  (define shake
    (lambda (ani intensity)
      (lambda (progress)
	(let* ([decay (- 1 progress)]
	       [angle (* progress 70.0)]
	       [dx (* intensity (sin angle) decay)]
	       [dy (* intensity (cos (* angle 1.3)) decay)])
	  (origin (ani progress)
		  (lambda (ox) (+ ox dx))
		  (lambda (oy) (+ oy dy)))
	  ))))

  (define appear
    (lambda (ani)
      (lambda (progress)
	(let* ([a (floor (* progress 255))])
	  (fade (ani progress) a)))
      ))

  (define disappear
    (lambda (ani)
      (lambda (progress)
	(let* ([a (floor (* (- 1 progress) 255))])
	  (fade (ani progress) a)))
      ))

  (define crossfade
    (lambda (ani1 ani2)
      (overlay
       (disappear ani1)
       (appear ani2))))

  (define overlay
    (lambda anis
      (lambda (progress)
	(apply
	 layer
	 (map (lambda (ani) (ani progress)) anis)))
      ))

  (define dissolve
    (lambda (ani mask)
      (lambda (progress)
	(mask-alpha (ani progress) mask progress)
	)))
  )
