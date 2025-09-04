(load-shared-object "background.raylib.macos.so")

(define init-fullscreen
  (foreign-procedure "InitFullscreen" (string) void))

(define display-image
  (foreign-procedure "DisplayImage" (string) void))

(define play-bgm
  (foreign-procedure "PlayBGM" (string) void))

(define show-image
  (lambda ()
    (init-fullscreen "Test screen")
    (display-image "../../assets/bg/livingroom.jpg")
    (play-bgm "../../assets/bgm/midnight-trip.mp3")))
