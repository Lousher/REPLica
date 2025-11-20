#!/usr/local/bin/chez --script
(import (only (tool) reads))
(define definition-keywords '(define define-syntax define-ffi))
(define collect-definitions
  (lambda (raw-file)
    (let* ([exps (call-with-input-file raw-file reads)]
	   [defs (filter (lambda (exp) (memv (car exp) definition-keywords)) exps)])
      (map cadr defs))))

(define rawfile->library
  (lambda (file)
    (let ([defs (collect-definitions file)])
      (call-with-output-file
	  (format "~a.lib" file)
	(lambda (p)
	  (display
	   (format "(library (TODO)\n ~a \n(import (chezscheme))\n(include \"~a\"))" (cons 'export defs) file) 
	   p))))))

(let ([raw-files (cdr (command-line))])
  (assert (for-all file-exists? raw-files))
  (for-each rawfile->library raw-files))




      
      
    
