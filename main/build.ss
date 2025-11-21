(import (chezscheme))

(optimize-level 3)
(compile-imported-libraries #t)
(generate-wpo-files #t)

(compile-library "raylib/ffi.ss")
(compile-library "raylib/constant.ss")
(compile-library "tool.ss")
(compile-library "monad.ss")

(compile-library "replica.ss")
(compile-program "entry.ss")

(make-boot-file "replica.boot"
		'("petite")
		"raylib/ffi.so"
		"raylib/constant.so"
		"tool.so"
		"monad.so"
		"replica.so"
		"entry.so")


