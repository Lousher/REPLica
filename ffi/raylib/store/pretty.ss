(import (chezscheme))

(define raw (with-input-from-file "raylib_api.ss" read))

(with-output-to-file "raylib_api.pretty.ss"
  (lambda ()
    (pretty-print raw))
  'replace)

(display "格式化完成!")
