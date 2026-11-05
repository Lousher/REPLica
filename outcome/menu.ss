(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")

(import (ffi raylib binding))
(import (game resource)) 
(import (game engine)) 
(import (game track))
(import (game clock))

(import (game picture))
(import (game animator))

(import (game clip))
(import (game envelope))

(import (game stage))
(import (game event))

(load-directory "store/")

(define game (init "config.ini"))

(define reveal
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resolve 'dissolve 'fs)
	      `(("texture1" . ,(ani1 p)) ("texture2" . ,(ani2 p)) ("rule" . ,(default (resolve 'wipes 3))) ("feather" . 0.01) ("progress" . ,p))))))
(define button-start (contain (resolve 'start 'png)))
(define button-start-hovered (contain (resolve 'start 'chosen 'png)))

(define background-track1 (on (freeze 0) (still (default (resolve 'morning)))))
(define button-start-track1 (on (freeze 0)
			(still button-start)))
(define button-start-track2 (on (freeze 0)
			(still button-start-hovered)))
(define music-track (on (loop 5) (plain (dry (resolve 'piano 'mp3)))))

(define button-start-stage
  (spawn (clicked? MOUSE_BUTTON_LEFT)
	 (lambda () music-track)
	 (toggle hovered?
		 button-start-track1
		 button-start-track2)))

(define background-trans (on (once 3) (reveal (still (default (resolve 'morning)))
					      (still (default (resolve 'afternoon))))))
(define background-track2 (on (freeze 0) (still (default (resolve 'afternoon)))))


(game
 (together
  (hold background-track1)
  (zoom 0.2 button-start-stage)))
