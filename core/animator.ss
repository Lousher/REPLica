(library (core animator)
  (export 
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
  
  (define static
    (lambda (pic)
      (lambda (progress)
	pic)))

  (define spin
    (lambda (pic angle)
      (lambda (progress)
	(rotate pic
		(lambda (r) (+ r (* progress angle)))))))

  (define shake
    (lambda (pic intensity)
      (lambda (progress)
	(let* ([decay (- 1 progress)]
	       [angle (* progress 70.0)]
	       [dx (* intensity (sin angle) decay)]
	       [dy (* intensity (cos (* angle 1.3)) decay)])
	  (origin pic
		  (lambda (ox) (+ ox dx))
		  (lambda (oy) (+ oy dy)))
	  ))))

  (define appear
    (lambda (ani)
      (lambda (progress)
	(let* ([a (floor (* progress 255))])
	  (fade ani a)))
      ))

  (define disappear
    (lambda (ani)
      (lambda (progress)
	(let* ([a (floor (* (- 1 progress) 255))])
	  (fade ani a)))
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
    (lambda (ani masked)
      (lambda (progress)
	(mask ani masked progress)
	)))
  )
