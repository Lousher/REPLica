(library-directories "main/")
(import (vm main)
	(vm isa))

(define code (make-bytevector 32)) ;; 8 条指令
(define constants '#("好感度不足..." "进入 True End！" 12 5))

;; R0: 当前好感度, R1: 增加值, R2: 阈值
;; 指令 0: LOADK R0, 3 (加载初始值 5)
(bytevector-u32-native-set! code 0  (make-instruction-ABx LOADK 0 3))
;; 指令 1: LOADK R1, 3 (加载增加值 5)
(bytevector-u32-native-set! code 4  (make-instruction-ABx LOADK 1 3))
;; 指令 2: ADD R0, R0, R1 (5 + 5 = 10)
(bytevector-u32-native-set! code 8  (make-instruction-ABC ADD 0 0 1))
;; 指令 3: LOADK R2, 2 (加载阈值 10)
(bytevector-u32-native-set! code 12 (make-instruction-ABx LOADK 2 2))

;; --- 分歧判定 ---
;; 指令 4: LT 0 R0 R2 (检查 R0 < R2, 即 10 < 10 是否成立)
;; 如果不成立（10 不小于 10），跳过指令 5
(bytevector-u32-native-set! code 16 (make-instruction-ABC LT 0 0 2))
;; 指令 5: JMP 0, 1 (如果好感度不足，跳过 True End 的文本显示)
(bytevector-u32-native-set! code 20 (make-instruction-AsBx JMP 0 1))

;; 指令 6: LOADK R3, 1 (True End 文本)
(bytevector-u32-native-set! code 24 (make-instruction-ABx LOADK 3 1))
;; 指令 7: SHOW R3, 0, 0
(bytevector-u32-native-set! code 28 (make-instruction-ABC SHOW 3 0 0))

(define v (make code constants))
(run v)
