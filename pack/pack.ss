;(library-directories "main/")

(import (tool bundle))

#| (pack "pack/main-menu.rpk"
'(("key-visual" "../assets/bg/apartment.morning.jpg")
("contract" "../assets/menu/main2x.png")
("btn-start" "../assets/menu/button/start.png")
("btn-start-chosen" "../assets/menu/button/start.chosen.png")
("btn-config" "../assets/menu/button/config.png")
("btn-config-chosen" "../assets/menu/button/config.chosen.png")
("btn-continue" "../assets/menu/button/continue.png")
("btn-continue-chosen" "../assets/menu/button/continue.chosen.png")
("btn-exit" "../assets/menu/button/exit.png")
("btn-exit-chosen" "../assets/menu/button/exit.chosen.png")
("btn-gallery" "../assets/menu/button/gallery.png")
("btn-gallery-chosen" "../assets/menu/button/gallery.chosen.png")
("btn-load" "../assets/menu/button/load.png")
("btn-load-chosen" "../assets/menu/button/load.chosen.png")
("sign" "../assets/sound/sign.mp3"))) 

(pack "pack/common.rpk"
'(("xiaolai.atlas" "pack/xiaolai.atlas.gray.png")
("xiaolai.bin" "pack/xiaolai.bin"))) |#

(pack "test.rpk"
      '(("t1" "test.png")
	("t2" "test2.png")))
