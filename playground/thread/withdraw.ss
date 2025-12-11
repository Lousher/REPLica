(define balance 100)
(define balance-lock (make-mutex 'account-lock)) ;; 给锁起个名字方便调试

(define (withdraw amount name)
  ;; 1. 进门先锁门：如果别人已经拿了锁，我会在这里一直等（阻塞）
  (mutex-acquire balance-lock)
  
  (printf "[~a] 正在检查余额...\n" name)
  (sleep (make-time 'time-duration 0 100000000)) ;; 模拟数据库延迟 0.1秒
  
  (if (>= balance amount)
      (begin
        (set! balance (- balance amount))
        (printf "[~a] 取款成功！余额剩余: ~a\n" name balance))
      (printf "[~a] 余额不足！\n" name))
  
  ;; 2. 办完事开门：必须释放，否则别人永远进不来（死锁）
  (mutex-release balance-lock))

;; 模拟夫妻二人同时取钱
(fork-thread (lambda () (withdraw 80 "丈夫")))
(fork-thread (lambda () (withdraw 80 "妻子")))

;; 等待一下看结果
(sleep (make-time 'time-duration 1 0))
