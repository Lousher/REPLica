(define cb-init
  (foreign-procedure "cb_init" () void))

(define register-callback
  (foreign-procedure "register_callback" (char void*) void))

(define event-loop
  (foreign-procedure __collect_safe "event_loop" () void))


(define callback
  (lambda (p)
    (let ([code (foreign-callable __collect_safe p (char) void)])
      (lock-object code)
      (foreign-callable-entry-point code))))

(define ouch
  (callback
   (lambda (c)
     (printf "Ouch! Hit by '~c'~%" c))))

(define rats
  (callback
   (lambda (c)
     (printf "Rats! Received '~c'~%" c))))

(cb-init)
(register-callback #\a ouch)
(register-callback #\c rats)
(register-callback #\e ouch)
