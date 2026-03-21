(library-directories "main/")
(import (vm main)
	(vm isa)
	(vm asm))



;test 1
#|(define my-bytecode
  (asm
    (LOADK 0 3)          ; R0 = 5 (初始好感)
    (LOADK 1 3)          ; R1 = 5 (增加值)
    (ADD 0 0 1)          ; R0 = R0 + R1 (10)
    (LOADK 2 2)          ; R2 = 12 (阈值)
    
    (LT 0 0 2)           ; 检查 R0 < R2 (10 < 12)
    (JMP "TrueEnd")      ; 如果匹配(True)，跳转到 TrueEnd 标签
    
    (TEXT 0)             ; 否则(不匹配则跳过 JMP)显示“好感度不足”
    (WAIT)
    (JMP "End")          ; 结束
    
    (LABEL "TrueEnd")
    (LOADK 3 1)
    (SHOW 3 0 0)         ; 显示“进入 True End！”
    (WAIT)
    
    (LABEL "End"))) |#

					;(run (make my-bytecode constants))

(define-values (code constants)
  (asm
    (LOADK 0 "bg.png")       ;; 不用再管索引了！汇编器会自动去重并映射
    (LOADK 1 1920)
    (LOADK 2 1080)
    (LABEL "draw")
    (SHOW 0 1 2)
    (LOADK 3 "Alice")
    (TEXT 3)
    (JMP "draw")
    (WAIT)))
(display constants)
(newline)
(run (make code constants))
