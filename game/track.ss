(library (game track) ;track is a function  win -> (resource)??
  (export on sequential parallel repeat)
  (import (chezscheme)
	  (game window))

  (define on
    (lambda (clock curve)
      (lambda (tl)
	(let ([p (clock tl)])
	  (if p (curve p) #f)))))

  (define sequential
    (lambda tracks
      (let ([current-idx 0])
	(lambda (tl)
	  (let loop ([idx current-idx])
	    (if (>= idx (length tracks))
		#f
		(let* ([trk (list-ref tracks idx)]
		       [res (trk tl)])
		  (if res
		      (begin (set! current-idx idx) res)
		      (loop (+ idx 1))))))))))

  (define parallel
    (lambda (combiner . tracks)
      (lambda (tl)
	(let* ([ress (map (lambda (trk) (trk tl)) tracks)]
	       [valid (filter (lambda (r) r) ress)])
	  (if (null? valid)
	      #f
	      (apply combiner valid))))))

  (define repeat
    (lambda (track-thunk)
      (let ([current (track-thunk)])
	(lambda (tl)
	  (let ([res (current tl)])
	    (if res res
		(begin
		  (set! current (track-thunk))
		  (current tl))))))))
  )
