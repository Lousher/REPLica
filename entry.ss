(import (replica)
	(chezscheme))
(call/cc 
 (lambda (k)
   (with-exception-handler
    (lambda (x)
      ;; 如果启动失败（例如 .so 文件还没编译好），打印提示并跳过
      (display "Notice: Auto-start skipped (Stories not compiled yet).\n")
      (k #f))
    (lambda ()
      ;; 尝试启动
      (replica "stories/prologue.1")))))

