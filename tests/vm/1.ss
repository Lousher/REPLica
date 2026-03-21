(library-directories "main/")
(import (vm main)
	(vm isa))

(define my-bytecode (make-bytevector 16)) ;  条指令 * 4 字节
;; 指令 0: LOADK R0, 0 (加载常量池第0项 "bg.png" 到 R0)
(bytevector-u32-native-set! my-bytecode 0 (make-insturction-ABx LOADK 0 0))
;; 指令 1: LOADK R1, 1 (加载常量池第1项 1920 到 R1)
(bytevector-u32-native-set! my-bytecode 4 (make-insturction-ABx LOADK 1 1))
;; 指令 2: SHOW R0, R1, R1 (在 R1, R1 坐标处绘制 R0)
(bytevector-u32-native-set! my-bytecode 8 (make-insturction-ABC SHOW 0 1 1))

(bytevector-u32-native-set! my-bytecode 12 (make-insturction-AsBx JMP 0 -4))

;; 运行时
(define my-vm (make my-bytecode '#("bg.png" 1920)))
(run my-vm)

