(library (game envelope)
  (export full)
  (import (chezscheme)
	  (game clip))

  #| envelop -> (p) -> clip |#

  #| 最简单的envelope是不做任何处理|#
  (define full
    (lambda (cp)
      (lambda (p) cp)))
  )
