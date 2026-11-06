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

(import (game window))

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

(define start-hovered? #f)
(define start-clicked? #f)

(define start-button-track
  (gate (lambda (tl)
	  (TraceLog LOG_ERROR (format "TL is ~a" tl))
	  start-hovered?)
	button-start-track2
	button-start-track1))

(define background-trans (on (once 3) (reveal (still (default (resolve 'morning)))
					      (still (default (resolve 'afternoon))))))
(define background-track2 (on (freeze 0) (still (default (resolve 'afternoon)))))


(game
 (change (lambda (win) start-clicked?)
  (together
   (hold background-track1)
   (zoom 0.2
	 (with (lambda (win)
		 (set! start-hovered? (hovered? win))
		 (set! start-clicked? ((clicked? MOUSE_BUTTON_LEFT) win)))
	   start-button-track)))
  (hold background-trans)
  ))

