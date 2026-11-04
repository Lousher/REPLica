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
(import (game ticker))
(import (game tool))

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

(define rule (above (beside (default (resource 'wipes 2))
			    (default (resource 'wipes 3)))
		    (beside (default (resource 'wipes 4))
			    (default (resource 'wipes 5)))))

(define bgm (loop 3 (plain (dry (resource 'piano 'mp3)))))
(define c1-pic (contain (resource 'c1 'png)))
(define c2-pic (contain (resource 'c2 'png)))

(define shaded-ani
  (lambda (ani1 ani2)
    (lambda (p)
      (shaded (resource 'dissolve 'fs)
	      `(("texture2" . ,(ani2 p)) ("texture1" . ,(ani1 p))
		("rule" . ,rule) ("progress" . ,p) ("feather" . 0.0))))))

(define ani1 (crossfade (still (default (resource 'morning)))
			(still (default (resource 'afternoon)))))

(define ani2 (shaded-ani (still (scale (default (resource 'afternoon)) 2))
			 (still (default (resource 'afternoon)))))

(define mor (default (resource 'morning)))
(define aft (default (resource 'afternoon)))
(define four-matrix-pic (above (beside mor aft)
			       (beside aft mor)))

(define s2 (parallel
	    (hold (loop 2 ani2))))

(define char-stage (hold (pingpong 5 (motivate
				      (still c1-pic)
				      (lambda (p)
					(lambda (x y)
					  (values (+ (- x 960) (* p 1920)) y)))))))

(define s1 (change (clicked? MOUSE_BUTTON_LEFT)
		   (parallel (hold bgm)
			     (hold  (loop 3 (still mor))))
		   s2))

(define char-changed-s (toggle hovered?
			       (hold (loop 3 (still c1-pic)))
			       (hold (loop 3 (still c2-pic)))))



(define g (init "config.ini"))


(g (column (row s1 char-changed-s s1 char-changed-s s1) (row char-changed-s s1 char-changed-s s1 char-changed-s) ))

