(library-directories "main/")
(import (chezscheme)
	(tool bundle))

(define dummy-data (make-bytevector (* 100 1024 1024) 255))
(define dummy-key (string->utf8 "replica_secret01"))

(display "=== 测试 1: 旧版 64 位解密 (带 GC 风暴) ===\n")
;; 把你原先 bundle.ss 里的旧版 xor-transform! 复制过来重命名为 old-xor
(time (u64-xor-transform! dummy-data dummy-key))

(display "\n=== 测试 1: 新版 32 位解密 (零分配) ===\n")
;; 把我之前给你的新版 xor-transform! 复制过来重命名为 new-xor
(time (u32-xor-transform! dummy-data dummy-key))
