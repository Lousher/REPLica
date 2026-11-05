(load-shared-object "ffi/raylib/libraylib.so.6.2.0")
(load-shared-object "ffi/rini/librini.so")
(import (ffi raylib binding))
(import (game engine))
(import (game stage))
(import (game resource))
(import (game picture))
(import (game animator))
(import (game clip))
(import (game envelope))
(import (game event))
(import (game clock))
(import (game track))
(import (game tool))
(import (game window))
(import (game type))

(define ANSI-RESET "\x1B;[0m")

(define my-tracelog-callback
  (lambda (log-level str va-list)
    (let ([color (case log-level
                   [(0) "\x1B;[90m"]	 ; ALL   - 灰
                   [(1) "\x1B;[90m"]	 ; TRACE - 灰
                   [(2) "\x1B;[36m"]	 ; DEBUG - 青
                   [(3) "\x1B;[32m"]	 ; INFO  - 绿
                   [(4) "\x1B;[33m"]	 ; WARNING - 黄
                   [(5) "\x1B;[31m"]	 ; ERROR - 红
                   [(6) "\x1B;[1;97;41m"] ; FATAL - 白字红底
                   [(7) "\x1B;[37m"]	 ; NONE
                   [else "\x1B;[0m"])])
      (display color)
      (display str)
      (display ANSI-RESET)
      (newline))))

(define cb-code
  (foreign-callable my-tracelog-callback
		    (integer-32 string void*)
		    void))
(lock-object cb-code)
(SetTraceLogCallback (foreign-callable-entry-point cb-code))

(alias resource resource-fuzzy-query)

(load-directory ".")

(define shaded-ani
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resource 'dissolve 'fs)
	      `(("texture2" . ,(ani2 p)) ("texture1" . ,(ani1 p))
		("rule" . ,rule) ("progress" . ,p) ("feather" . 0.0))))))

(define c1-pic (contain (resource 'c1 'png)))
(define c2-pic (contain (resource 'c2 'png)))
(define mor-pic (default (resource 'morning)))
(define c-moving-curve
  (lambda (c-pic)
    (motivate (still c-pic)
	      (lambda (p)
		(lambda (x y)
		  (values (+ (- x 300) (* p 600)) y))))))

(define c-clock (after 3 (pingpong 5)))
(define bg-clock (loop 5))

(define c1-track (on c-clock (c-moving-curve c1-pic)))
(define c2-track (on c-clock (c-moving-curve c2-pic)))
(define bg-track (on bg-clock (still mor-pic)))

;; 在 event.ss 或 mouse.ss 中

(define c1-ani (c-moving-curve c1-pic))

(define s-c (toggle (inside-animator? c1-track)
		    (hold c1-track)
		    (hold c2-track)))
(define s-bg (hold bg-track))

(define g (init "config.ini"))

(g (column (row s-c s-bg) (row s-bg s-c) ))





