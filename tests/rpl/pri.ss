; executed in root folder
(library-directories "main/")
(import (rpl eval))

(define test-scripts
  '(
    (bundle "tests/rpl/pri.rpk")
    (assets
     (texture bgp "avenue")
     (texture bt "tab"))

    (origin 0.5 0.5
	    (anchor 0.5 0.5
		    (rotate 90
			    (scale 0.2
				   (show bgp)))))
    
    ))

(render test-scripts)
