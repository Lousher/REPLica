(library (core animator)
  (export
   picture->animator
   static spin shake
   crossfade overlay
   appear disappear  dissolve
   ease letterboxing concat
   x-move backward stagger
   )
  (import
   (ffi raylib binding)
   (core frame)
   (core type)
   (only (core picture) *TINT*)
   (chezscheme)
   (design color)
   (core picture)
   (core layout)
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
	  (at (ani progress)
	      (lambda (ox) (+ ox dx))
	      (lambda (oy) (+ oy dy)))
	  ))))

  (define x-move
    (lambda (ani distance)
      (lambda (progress)
	(at (ani progress)
	    (lambda (ax) (+ ax (* distance progress)))
	    #f)
	)))

  (define appear
    (lambda (ani)
      (lambda (progress)
	(let* ([p (if progress progress 1.0)]
	       [a (floor (* p 255))])
	  (fade (ani progress) a)))
      ))

  (define disappear
    (lambda (ani)
      (lambda (progress)
	(let* ([p (if progress progress 1.0)]
	       [a (floor (* (- 1 p) 255))])
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

  (define ease
    (lambda (ani fn)
      (lambda (progress)
	(lambda (f)
	  ((ani (fn progress)) f)))))

  (define backward
    (lambda (ani)
      (lambda (progress)
	(ani (- 1.0 progress)))))

  (define letterboxing
    (case-lambda
      [(ani ratio c)
       (lambda (progress)
	 (let ([current-ratio (- 1.0 (* progress (- 1.0 ratio)))])
	   (letterbox (ani progress) current-ratio c)))]
      [(ani ratio)
       (letterboxing ani ratio black)]))

  (define (scan proc init lst)
    (let loop ([rest lst] [current init] [acc '()])
      (if (null? rest)
          (reverse acc)
          (let ([next-val (proc current (car rest))])
            (loop (cdr rest) next-val (cons next-val acc))))))
  
  (define concat
    (lambda (anis durs)
      (assert (= (length anis) (length durs)))
      (assert (= 1 (apply + durs)))
      (let* ([len (length durs)]
	     [end-ticks (scan + 0.0 durs)]
	     [start-ticks (cons 0.0 (list-head end-ticks (- len 1)))]
	     [segs (map list start-ticks end-ticks anis durs)])
	(lambda (p)
	  (let ([progress (or p 1.0)])
	    (let ([seg (find (lambda (s) (<= (car s) progress (cadr s)))
			     segs)])
	      (let ([start (car seg)]
		    [end (cadr seg)]
		    [ani (list-ref seg 2)]
		    [dur (list-ref seg 3)])
		(let ([ani-p (min 1.0 (/ (- progress start) dur))])
		  (ani ani-p)))))))))

  (define stagger
    (lambda (anis intervals)
      (assert (= (length anis) (length intervals)))
      (assert (for-all (lambda (i) (<= 0 (car i) (cdr i) 1)) intervals))
      (lambda (p)
	(let ([progress (or p 1.0)])
	  (apply layer
		 (map
		  (lambda (ani i)
		    (let* ([start (car i)]
			   [end (cdr i)]
			   [local-p (cond
				     [(<= progress start) 0.0]
				     [(>= progress end) 1.0]
				     [else (/ (- progress start) (- end start))])])
		      (ani local-p)))
		  anis intervals))))))
  )
