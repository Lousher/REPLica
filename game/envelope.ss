(library (game envelope)
  (export plain)
  (import (chezscheme)
	  (game clip))

  #| envelop -> (p) -> clip |#

  #| 最简单的envelope是不做任何处理|#
  (define plain
    (lambda (cp)
      (lambda (p) cp)))

  )
