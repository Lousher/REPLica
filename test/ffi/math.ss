(define c-add
  (foreign-procedure "add" (int int) int))

(display (format "3 + 4 = ~a\n" (c-add 3 4)))
