(import (monad))

(define pickup
  (lambda (item)
    (modify (lambda (pack)
	      (cons item pack)))))

(define has?
  (lambda (item)
    (perform
     (inv <- ref)
     (return (and (memv item inv) #t)))))

(define journey
  (perform
   (pickup 'sword)
   (pickup 'shield)
   (has-sword? <- (has? 'sword))

   (if has-sword?
       (pickup 'health-potion)
       (pickup 'wooden-stick))

   (inv <- ref)
   (return inv)))
