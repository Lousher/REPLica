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

(load-directory "store/")

(define game (init "config.ini"))

(define reveal
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resolve 'dissolve 'fs)
	      `(("texture1" . ,(ani1 p)) ("texture2" . ,(ani2 p)) ("rule" . ,(default (resolve 'wipes 3))) ("feather" . 0.01) ("progress" . ,p))))))

(define background-track1 (on (freeze 0) (still (default (resolve 'morning)))))

(define background-changing-track
  (sequential
   (on (once 5) (reveal (still (default (resolve 'morning)))
			   (still (default (resolve 'afternoon)))))
   (on (freeze 0) (still (default (resolve 'morning))))))


(define bgm-enve (plain (dry (resolve 'piano 'mp3))))
(define bgm-track (on (loop 3) bgm-enve))


(game (together
       (enact bgm-track)
       (enact background-changing-track)))

