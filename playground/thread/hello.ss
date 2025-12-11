(display "Main: Beginning Work\n")

(fork-thread
 (lambda ()
   (sleep (make-time 'time-duration 0 2))
   (display "Helper: Side work is done\n")))

(display "Main: Still Working\n")

(sleep (make-time 'time-duration 2 0))
(display "Main: Work Done!\n")
