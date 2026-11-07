(library (game envelope)
  (export plain)
  (import (chezscheme))

  #| envelop -> (p) -> clip |#

  #| 最简单的envelope是不做任何处理|#
  (define plain
    (lambda (cp)
      (lambda (p) cp)))

  )
