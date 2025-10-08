#!/usr/local/bin/chez --script

(load "../main/tools.ss")
	  
(let* ([file (cadr (command-line))]
       [port (open-input-file file)]
       [scenes (reads port)]
       [params (map cdr scenes)]
       [param-alists (map parse-params params)]
       [texts (map (lambda (l)
		     (cond
		      [(assoc ':text l) => cdr]
		      [else #f])) param-alists)]
       [avail (filter (lambda (x) x) texts)])
  (let ([output (open-output-file "allchars.txt" '(replace))])
    (for-each
     (lambda (strings)
       (for-each
	(lambda (str)
	  (display str output))
	strings))
     avail)))

       

  
  
