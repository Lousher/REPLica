(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")

(import (game resource)) 
(import (game engine))
(import (game picture))
(import (game clock))
(import (game animator))
(import (game track))
(import (game stage))

(import (game clip))
(import (game envelope))
(import (game event))
(import (only (ffi raylib binding) MOUSE_BUTTON_LEFT))

(load-directory "store/")

(define game (init "config.ini"))

(define rule-picture (above (beside (default (resolve 'wipes 3)) (default (resolve 'wipes 4)))
			    (beside (default (resolve 'wipes 5)) (default (resolve 'wipes 6)))))
(define reveal
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resolve 'dissolve 'fs)
	      `(("texture1" . ,(ani1 p)) ("texture2" . ,(ani2 p))
		("rule" . ,rule-picture) ("feather" . 0.01) ("progress" . ,p))))))

(define background-track1 (on (freeze 0) (still (default (resolve 'morning)))))
(define background-track2 (on (freeze 0) (still (default (resolve 'afternoon)))))

(define background-changing-track
  (sequential
   (on (once 5) (reveal (still (default (resolve 'morning)))
			(still (default (resolve 'afternoon)))))
   (on (freeze 0) (still (default (resolve 'afternoon))))))

(define button-track (on (freeze 0)
			 (still (contain (resolve 'start 'png)))))
(define button-chosen-track (on (freeze 0)
				(still (contain (resolve 'start 'chosen 'png)))))

(define bgm-enve (plain (dry (resolve 'piano 'mp3))))
(define bgm-track (on (loop 4) bgm-enve))

(define end? #f)

(game
 (together
  (enact background-track1)
  (slot 0.05 0.05 0.2 0.2
	(together
	 (listen (clicked? MOUSE_BUTTON_LEFT)
		 (lambda (_) (set! end? #t)))
	 (branch hovered?
		 (enact button-chosen-track)
		 (enact button-track))))))
