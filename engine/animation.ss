(library (engine animation)
  (export animate
	  animations-update!
	  animation-stop
	  animation-stop-on-node
	  )
  (import (chezscheme)
	  (scene node)
	  (engine easing)
	  (only (raylib ffi) GetTime))

  (define-record-type animation
    (fields (mutable target)
	    (mutable property)
	    (mutable start)
	    (mutable duration)
	    (mutable from)
	    (mutable to)
	    (mutable easing)
	    (mutable loop?)
	    (mutable pingpong?)
	    (mutable on-finish)))

  (define *active-animations* '())

  (define set-node-property!
    (lambda (node prop val)
      (case prop
	[(x) (node-x-set! node val)]
	[(y) (node-y-set! node val)]
	[(scale) (node-scale-set! node val)]
	[(rotation) (node-rotation-set! node val)]
	[(alpha) (node-alpha-set! node val)]
	[else (error 'set-node-property! "Unknown property" prop)])))

  (define lerp
    (lambda (from to t)
      (+ from (* t (- to from)))))

  
  (define animate
    (lambda (node prop from to duration . opts)
      (let* ([start (GetTime)]
	     [easing (let ([v (assv 'easing opts)])
		       (if v (cdr v) linear))]
	     [loop? (let ([v (assv 'loop? opts)])
		      (if v (cdr v) #f))]
	     [pingpong? (let ([v (assv 'pingpong? opts)])
			  (if v (cdr v) #f))]
	     [on-finish (let ([v (assv 'on-finish opts)])
			  (if v (cdr v) #f))])
	(let ([anim (make-animation node prop start duration from to easing loop? pingpong? on-finish)])
	  (set! *active-animations* (cons anim *active-animations*))
	  anim))))

  (define animations-update!
    (lambda ()
      (let loop ([remaining '()]
		 [anims *active-animations*])
	(if (null? anims)
	    (set! *active-animations* (reverse remaining))
	    (let* ([a (car anims)]
		   [now (GetTime)]
		   [elapsed (- now (animation-start a))]
		   [dur (animation-duration a)])
	      (if (>= elapsed dur)
		  (begin
		    (set-node-property! (animation-target a) (animation-property a) (animation-to a))
		    (when (animation-on-finish a)
		      ((animation-on-finish a)))
		    (cond
		     [(animation-pingpong? a)
		      (let ([new-from (animation-to a)]
			    [new-to (animation-from a)])
			(animation-from-set! a new-from)
			(animation-to-set! a new-to)
			(animation-start-set! a now)
			(loop (cons a remaining) (cdr anims)))]
		     [(animation-loop? a)
		      (animation-start-set! a now)
		      (loop (cons a remaining) (cdr anims))]
		     [else (loop remaining (cdr anims))]))
		  (let* ([t (/ elapsed dur)]
			 [eased-t ((animation-easing a) t)]
			 [val (lerp (animation-from a) (animation-to a) eased-t)])
		    (set-node-property! (animation-target a) (animation-property a) val)
		    (loop (cons a remaining) (cdr anims)))))))))

  (define animation-stop
    (lambda (anim)
      (set! *active-animations*
	    (filter
	     (lambda (a) (not (equal? a anim)))
	     *active-animations*))))

  (define animation-stop-on-node
    (lambda (node)
      (set! *active-animations*
	    (filter
	     (lambda (a) (not (equal? (animation-target a) node)))
	     *active-animations*))))
  )
