(define test-none
  (lambda ()
    (let ([p (open-file-output-port "test_none.txt"
				    (file-options no-fail)
				    (buffer-mode none)
				    (native-transcoder))])
      (do ([i 0 (+ i 1)])
	  ((= i 1000000))
	(put-string p "data\n"))
      (close-port p))))

(define test-block
  (lambda ()
    (let ([p (open-file-output-port "test_none.txt"
				    (file-options no-fail)
				    (buffer-mode block)
				    (native-transcoder))])
      (do ([i 0 (+ i 1)])
	  ((= i 1000000))
	(put-string p "data\n"))
      (close-port p))))

(define test-line
  (lambda ()
    (let ([p (open-file-output-port "test_none.txt"
				    (file-options no-fail)
				    (buffer-mode line)
				    (native-transcoder))])
      (do ([i 0 (+ i 1)])
	  ((= i 1000000))
	(put-string p "data\n"))
      (close-port p))))

(time (test-none))
(time (test-line))
(time (test-block))
