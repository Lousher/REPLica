(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")

(import (game resource)) 
(import (game engine))
(import (game picture))
(import (game clock))
(import (game animator))
(import (game track))
(import (game stage))

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

(game (show background-track1))

