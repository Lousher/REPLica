(library (combinator)
  (export parallel sequential)
  (import (chezscheme))

  (define parallel
    (lambda animators
      (lambda (passed)
	(lambda (state)
	  (for-each
	   (lambda (anim)
	     ((anim passed) state))
	   animators)))))

  (define sequential)
  )
