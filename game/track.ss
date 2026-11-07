(library (game track) ;track is a function  win -> (resource)??
  (export on sequential repeat parallel
	  prefetch)
  (import
   (chezscheme)
   (only (game effect) effect-deps))
  #| track bind clock and curve, so it's a t(number) -> p(progress) func|#
  (define on
    (lambda (clock curve)
      (lambda (t)
	(let ([p (clock t)])
	  (if p (curve p) #f)))))
  
  (define prefetch ;quite special
    (lambda (pre-t trk)
      (lambda (t)
	(let ([out (trk (+ t pre-t))])
	  (if out (effect-deps out) #f)))))

  (define sequential
    (lambda tracks
      (let ([current-idx 0])
	(lambda (t)
	  (let loop ([idx current-idx])
	    (if (>= idx (length tracks))
		#f
		(let* ([trk (list-ref tracks idx)]
		       [res (trk t)])
		  (if res
		      (begin (set! current-idx idx) res)
		      (loop (+ idx 1))))))))))

  (define parallel
    (lambda (combiner . tracks)
      (lambda (t)
	(let* ([ress (map (lambda (trk) (trk t)) tracks)]
	       [valid (filter (lambda (r) r) ress)])
	  (if (null? valid)
	      #f
	      (apply combiner valid))))))

  (define repeat
    (lambda (track-thunk)
      (let ([current (track-thunk)])
	(lambda (t)
	  (let ([res (current t)])
	    (if res res
		(begin
		  (set! current (track-thunk))
		  (current t))))))))
  )
