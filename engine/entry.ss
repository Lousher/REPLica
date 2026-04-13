(library (engine entry)
  (export replica)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (scene renderer)
	  (engine resource))
					; Manually Control FPS, raylib got some issues
  (define FPS 60)
  (define FRAME_TARGET_TIME (/ 1.0 FPS)) 

  (define test-node1)
  (define test-node2)
  (define test-node3)

  (define replica
    (lambda ()
      (InitWindow 1920 1080 "REPLica Engine")
      (InitAudioDevice)
      (let ([rm (make-manager)])
	(mount rm "test.rpk")
	(begin 
	  (set! test-node1 (make-texture-node rm 1 "t1"))
	  (node-pivot-x-set! test-node1 0.5)
	  (node-pivot-y-set! test-node1 0.5)
	  (node-x-set! test-node1 960)
	  (node-y-set! test-node1 540)
	  (node-scale-set! test-node1 0.5)
	  (node-rotation-set! test-node1 90)
	  (set! test-node2 (make-texture-node rm 2 "t2"))
	  (set! test-node3 (make-texture-node rm 3 "t1")))
	(let ([root (make-root-node 1920 1080)])
	  (node-add! root test-node1)
	  (node-add! root test-node2)
	  (node-add! root test-node3)
	  (let loop ([time (GetTime)])
	    (unless (WindowShouldClose)
	      (loader-update! rm)
	      (BeginDrawing)
	      (ClearBackground BLANK)
	      (render root)
	      (EndDrawing)
					; FPS Control
	      (let* ([current-time (GetTime)]
		     [elapsed (- current-time time)]
		     [sleep-time (- FRAME_TARGET_TIME elapsed)]
		     [time-duration (make-time 'time-duration
					       (inexact->exact (floor (* sleep-time 1e9))) 0)])
		(when (> sleep-time 0)
		  (sleep time-duration)))
	      (loop (GetTime))))))
      (CloseAudioDevice)
      (CloseWindow))
    )

  )
