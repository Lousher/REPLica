(library-directories "main/")
(import (rpl eval))

(define menu-rpl
  '(
    (bundle "tests/rpl/menu.rpk")
    (assets
     (texture kv "key-visual")
     (texture contract "contract")
     (texture start "btn-start")
     (texture load "btn-load")
     (texture continue "btn-continue")
     (texture gallery "btn-gallery")
     (texture config "btn-config")
     (texture exit "btn-exit"))

    (scale 0.5
	   (parallel
	    (show kv)
	    (show contract)
	    (at 710 250
		(parallel
		 (at 0 0 (show start))
		 (at 0 100 (show continue))
		 (at 0 200 (show load))
		 (at 0 300 (show gallery))
		 (at 0 400 (show config))
		 (at 0 500 (show exit))))))
    
    ))

(render menu-rpl)
