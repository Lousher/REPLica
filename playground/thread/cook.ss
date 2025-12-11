(define buffer #f)           ;; 共享数据区
(define lock (make-mutex))   ;; 保护数据的锁
(define ready (make-condition 'data-ready)) ;; 条件：数据准备好了

;; --- 消费者 (吃货) ---
(define (consumer)
  (with-mutex lock
    (printf "消费者: 肚子饿了，检查盘子...\n")
    
    ;; 循环检查！这是标准范式，防止“虚假唤醒”
    (let loop ()
      (if (not buffer) ;; 如果盘子是空的
          (begin
            (printf "消费者: 没吃的，睡觉等待...\n")
            ;; 【关键】: 释放 lock，进入睡眠。等有人 signal 后，重新拿锁，函数返回
            (condition-wait ready lock) 
            (printf "消费者: 被叫醒了，看看有没有吃的...\n")
            (loop)) ;; 醒来后再检查一次，确保真的有数据
          
          ;; 如果有数据
          (printf "消费者: 终于吃到了: ~a\n" buffer)))))

;; --- 生产者 (厨师) ---
(define (producer)
  (printf "生产者: 正在做饭 (耗时2秒)...\n")
  (sleep (make-time 'time-duration 2 0))
  
  (with-mutex lock
    (set! buffer "红烧肉")
    (printf "生产者: 菜做好了！发出信号。\n")
    (condition-signal ready))) ;; 叫醒【一个】正在等 ready 的线程

;; 启动
(fork-thread consumer)
(fork-thread producer)

(sleep (make-time 'time-duration 3 0))
