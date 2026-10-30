(import (tool pack))
(import (ffi rres binding))
(load-shared-object "ffi/rres/librres.so")

(pack-file "test/pack/test.txt" "test/pack/test.res" (container-format rres))
(assert (file-exists? "test/pack/test.res"))
