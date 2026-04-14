(import (tool bake))
(bake-sdf "./Xiaolai-Regular.ttf" "pack/xiaolai.atlas.png" "pack/xiaolai.bin" (map char->integer (string->list (call-with-input-file "pack/3500.txt" get-string-all))) 128 10)
