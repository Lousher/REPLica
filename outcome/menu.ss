(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")

(import (game resource)) 
(import (game engine)) 
(import (game track))
(import (game clock))

(import (game picture))
(import (game animator))

(import (game stage))
(import (game event))

(load-directory "store/asset/")

(define game (init "config.ini"))

(define background
  (hold (on (freeze)
	    (still (default (resolve 'morning))))))

(define place-button-nth
  (lambda (nor hov nth)
    (place (lambda (x y w h)
	     (values (* 0.1 w) (* 0.2 nth h) (* w 0.2) (* h 0.2)))
	   (toggle hovered?
		   (hold (on (freeze)
			     (still (contain nor))))
		   (hold (on (freeze)
			     (still (contain hov))))))))

(define buttons-with-hover
  (lambda normal-hoverd-pairs
    (let ([normal (map car normal-hoverd-pairs)]
	  [hovered (map cdr normal-hoverd-pairs)]
	  [len (length normal-hoverd-pairs)])
      (apply parallel
	     (map place-button-nth	      
	      normal hovered (iota len))))))

(define button-names '(start continue load config gallery exit))
(define button-pairs (map (lambda (name) (cons (resolve name 'png) (resolve name 'chosen 'png))) button-names))

(define combined
  (parallel
   background
   (apply buttons-with-hover button-pairs)))

(game combined)


