; executed in root folder
(library-directories "main/")
(import (rpl eval))

(define test-scripts
  '(
    (bundle "tests/rpl/pri.rpk")
    (assets
     (texture bgp "bg"))
    (show bgp)
    ))

(render test-scripts)
