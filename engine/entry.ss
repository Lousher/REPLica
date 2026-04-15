(library (engine entry)
  (export replica)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (scene renderer)
	  (engine resource)
	  (engine animation)
	  (engine easing) ;test
	  )
					; Manually Control FPS, raylib got some issues
  (define FPS 60)
  (define FRAME_TARGET_TIME (/ 1.0 FPS)) 

  (define fps-control
    (lambda (prev-time)
      (let* ([current-time (GetTime)]
	     [elapsed (- current-time prev-time)]
	     [sleep-time (- FRAME_TARGET_TIME elapsed)])
	(when (> sleep-time 0)
	  (let ([time-duration
		 (make-time
		  'time-duration
		  (inexact->exact (floor (* sleep-time 1e9))) 0)])
	    (sleep time-duration))))))
  
  (define test-node1)
  (define test-node2)
  (define test-node3)
  (define char-node1)
  (define char-node2)
  (define char-node3)
  (define char-node4)
  (define char-node5)
  (define char-node6)
  (define char-node7)
  (define char-node8)
  (define text-node1)

  (define replica
    (lambda ()
      (InitWindow 1920 1080 "REPLica Engine")
      (InitAudioDevice)
      (init-renderer "sdf.fs")
      (let ([rm (make-manager)])
	(mount rm "test.rpk")
	(begin 
	  (set! test-node1 (make-texture-node rm 1 "t1"))
	  (node-x-set! test-node1 500)
	  (node-y-set! test-node1 500)
	  (animate test-node1 'x 500 1000 2.0
		   `(easing . ,ease-in-out-quad)
		   `(pingpong? . ,#t))
	  (node-scale-set! test-node1 0.5)
					;	  (set! test-node2 (make-texture-node rm 2 "t2"))
					;	  (set! test-node3 (make-texture-node rm 3 "t1"))
	  (set! char-node1 (make-char-node rm 4 "xiaolai" #\A))
	  (set! char-node2 (make-char-node rm 5 "xiaolai" #\g))
	  (set! char-node3 (make-char-node rm 6 "xiaolai" #\y))
	  (set! char-node4 (make-char-node rm 7 "xiaolai" #\j))
	  (set! char-node5 (make-char-node rm 8 "xiaolai" #\p))
	  (set! char-node6 (make-char-node rm 9 "xiaolai" #\q))
	  (set! char-node7 (make-char-node rm 10 "xiaolai" #\好))
	  (set! char-node8 (make-char-node rm 11 "xiaolai" #\啊))
	  (set! text-node1
		(make-text-node
		 12
		 (list char-node1 char-node2 char-node3 char-node4 char-node5 char-node6 char-node7 char-node8) 10))
	  (node-x-set! text-node1 400)
	  (node-y-set! text-node1 200)
	  (node-scale-set! text-node1 1)
	  (node-rotation-set! text-node1 0)
	  )
	(let ([root (make-root-node 1920 1080)])
	  (node-add! root test-node1)
					;	  (node-add! root test-node2)
					;	  (node-add! root test-node3)
	  (node-add! root text-node1)
	  (let loop ([time (GetTime)])
	    (unless (WindowShouldClose)
	      (loader-update! rm)
	      (animations-update!)
	      (BeginDrawing)
	      (ClearBackground BLACK)
	      (render root)
	      (EndDrawing)
	      (fps-control time)	; FPS control
	      (loop (GetTime))))))
      (uninit-renderer)
      (CloseAudioDevice)
      (CloseWindow))
    )

  )
