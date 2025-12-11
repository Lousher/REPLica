(define 锁 (make-mutex)) ;; 创建一把锁

(define (说话 名字)
  (mutex-acquire 锁) ;; 【抢锁】拿到令牌！别人得等着
  (display (format "~a: 开始说话..." 名字))
  (sleep (make-time 'time-duration 0 500000000)) ;; 模拟说话说了 0.5 秒
  (display (format " 说完了！\n"))
  (mutex-release 锁)) ;; 【放锁】还回令牌，下一个人可以抢了

;; 同时启动两个线程抢着说话
(fork-thread (lambda () (说话 "【帮厨 A】")))
(fork-thread (lambda () (说话 "【帮厨 B】")))

(sleep (make-time 'time-duration 2 0))
