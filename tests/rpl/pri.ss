; executed in root folder
(library-directories "main/")
(import (rpl eval))

(define test-scripts
  '(
    (bundle "tests/rpl/pri.rpk")
    (assets
     (texture bgp "avenue")
     (texture bt "tab"))
    (show bgp)
    (show bt)
    ))

(render test-scripts)
