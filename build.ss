(import (chezscheme))

(make-boot-file "replica.mac.boot"
		'("petite" "scheme")
		"main/tool.ss"
		"main/state.ss"
		"main/transpiler.ss"
		"main/raylib/ffi.ss"
		"main/raylib/constant.ss"
		"main/loader.ss"
		"main/directive.ss"
		"main/replica.ss"
		"entry.ss"
		)

(display "<< Build Replica Story Successfully >>\n")
