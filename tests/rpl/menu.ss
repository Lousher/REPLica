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
     (texture exit "btn-exit")
     (texture start-h "btn-start-chosen")
     (texture load-h "btn-load-chosen")
     (texture continue-h "btn-continue-chosen")
     (texture gallery-h "btn-gallery-chosen")
     (texture config-h "btn-config-chosen")
     (texture exit-h "btn-exit-chosen"))

    (prefab hoverd-btn (no ho)
	    (branch
	     [(hovered? 480 180) (show ho)]
	     [else (show no)]))

    (prefab menu-buttons (x y)
	    (at x y
		(parallel
		 (at 0 0 (hoverd-btn start start-h))
		 (at 0 100 (hoverd-btn continue continue-h))
		 (at 0 200 (hoverd-btn load load-h))
		 (at 0 300 (hoverd-btn gallery gallery-h))
		 (at 0 400 (hoverd-btn config config-h))
		 (at 0 500 (hoverd-btn exit exit-h)))))

    (scale 0.5
	   (parallel
	    (show kv)
	    (show contract)
	    (menu-buttons 710 250)))
    
    ))

(render menu-rpl)
