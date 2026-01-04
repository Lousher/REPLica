(import (chezscheme) 
        (transpiler)) 

(define (compile-story name)
  (let ([rpl (string-append "stories/" name ".rpl")]
        [ril (string-append "stories/" name ".ril")]
        [so  (string-append "stories/" name ".so")])
    
    (display (format "Processing ~a...\n" name))
    
    ;; 1. RPL -> RIL (转译)
    (rpl->ril rpl ril)
    
    ;; 2. RIL -> SO (编译)
    ;; 注意：这里编译出来的 .so 会自动链接到 replica.boot 里的库实例
    (compile-file ril)
    
    (display (format "Compiled: ~a\n" so))))

;; 在这里列出你所有的故事文件
(compile-story "prologue.1")
(compile-story "prologue.2")
(compile-story "prologue.3")
;; (compile-story "chapter.1") ...

(display "All stories compiled successfully!\n")
