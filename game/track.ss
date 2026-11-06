(library (game track) ;track is a function  win -> (resource)??
  (export on sequential repeat parallel gate warp)
  (import (chezscheme)
	  (game world)
	  (game effect))

  (define on
    (lambda (clock curve)
      (lambda (tl)
	(let ([p (clock tl)])
	  (if p (curve p) #f)))))

  (define gate
    (lambda (ev trk1 trk2)
      (lambda (tl)
	(let ([res (ev tl)])
	  (if res
	      (trk1 tl)
	      (trk2 tl))))))

  ;; 通用变换器
  (define (warp fn trk)
    (lambda (tl)
      (let ([res (trk tl)])
	(cond
         [(not res) #f]
         [(eqv? (void) res) res]
	 [(effect? res) (fn res)]
         [else res]))))

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
