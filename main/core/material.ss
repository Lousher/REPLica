(library (core material)
  (export texture)
  (import (chezscheme))

  (define resource-texture
    (lambda (ptr)
      (list 'texture ptr)))

  (define resource-empty
    (lambda ()
      (list 'empty '())))

  (define texture
    (lambda (ptr)
      (lambda (t)
	(resource-texture ptr))))
  )
