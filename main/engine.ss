;; compile-engine.ss
(import (chezscheme))

(display ">>> 正在锁定引擎版本 (Compiling Engine)...\n")

(define (compile-lib path)
  (printf "Compiling ~a ... " path)
  (compile-library path) ;; 生成 .so 文件
  (printf "Done.\n"))

;; 注意顺序：被依赖的先编译
(compile-lib "main/tool.ss")
(compile-lib "main/state.ss")
(compile-lib "main/transpiler.ss")
(compile-lib "main/raylib/ffi.ss")
(compile-lib "main/raylib/constant.ss")
(compile-lib "main/loader.ss")
(compile-lib "main/directive.ss")
(compile-lib "main/replica.ss")

(display ">>> 引擎已锁定！现在你可以反复运行 entry.ss 了。\n")
