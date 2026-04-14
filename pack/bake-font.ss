(import (tool bake))
(bake-sdf
 "./Xiaolai-Regular.ttf"
 "xiaolai.atlas.png"
 "xiaolai.bin"
 (append
  (map char->integer (string->list (call-with-input-file "pack/3500.txt" get-string-all)))
  (map (lambda (n) (+ n 32)) (iota 95))
  ) 128 10)
