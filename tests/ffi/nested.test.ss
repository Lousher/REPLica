(import (chezscheme))

(load-shared-object "./libnested.dylib")

;; --- 核心宏定义 (提取自你的 ffi.ss) ---

(define-ftype Point (struct [x float] [y float]))
(define-ftype PointPtr (* Point))
(define-ftype Info (struct [id int] [count int]))

;; --- FFI 声明 ---
;; 这里使用你最喜欢的 & 定义
(define GeneratePoints
  (foreign-procedure "GeneratePoints" ((* PointPtr) int) (& Info)))

;; --- 运行实验 ---
(let ([num 5])
  (let ([box (make-ftype-pointer PointPtr (foreign-alloc (ftype-sizeof PointPtr)))]
	[info (make-ftype-pointer Info (foreign-alloc (ftype-sizeof Info)))])
    ;; 调用：就像函数直接返回了对象一样！
    (let ([_ (GeneratePoints info box num)])
      (display (format "ID: ~a, Count: ~a\n" 
                       (ftype-ref Info (id) info)
                       (ftype-ref Info (count) info)))
      
      (let ([pts-ptr (ftype-ref PointPtr () box)])
        (display (format "Point 0: (~a, ~a)\n" 
                         (ftype-ref Point (x) pts-ptr 5)
                         (ftype-ref Point (y) pts-ptr 5))))
    )))
