; executed in root folder
(library-directories "main/")
(import (rpl eval))

(define test-scripts
  '(
    (bundle "tests/rpl/pri.rpk")
    (assets
     (texture bgp "avenue")
     (texture bt "tab"))
    (alpha 0.5
	   (parallel
	    (show bgp)
		   (scale 1.5
			  (rotate 20
				  (show bt)))))
    ))

(render test-scripts)
