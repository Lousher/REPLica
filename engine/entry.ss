(library (engine entry)
  (export replica)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (scene renderer)
	  (tool bundle))
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
      (let ([b (mount "test.rpk")])
	(let-values ([(ext1 data1 len1) (ref b "t1")]
		     [(ext2 data2 len2) (ref b "t2")])
	  (let* ([img1 (LoadImageFromMemory ext1 data1 len1)]
		 [img2 (LoadImageFromMemory ext2 data2 len2)]
		 [tex1 (LoadTextureFromImage img1)]
		 [tex2 (LoadTextureFromImage img2)])
	    (UnloadImage img1)
	    (UnloadImage img2)
	    (set! test-node1 (make-node 1 'texture tex1 "test.png"))
	    (set! test-node2 (make-node 2 'texture tex2 "test2.png"))
	    (set! test-node3 (make-node 3 'texture tex1 "test.png"))
	    )
	  (node-pivot-x-set! test-node1 1)
	  (node-pivot-y-set! test-node1 1)
	  (node-x-set! test-node1 960)
	  (node-y-set! test-node1 540)
	  (node-scale-set! test-node1 0.5)
	  (node-rotation-set! test-node1 90)
	  (node-color-set! test-node1 '(255 255 255 255))
	  (node-alpha-set! test-node1 1)


	  (node-pivot-x-set! test-node2 1)
	  (node-pivot-y-set! test-node2 1)
	  (node-x-set! test-node2 960)
	  (node-y-set! test-node2 540)
	  (node-scale-set! test-node2 0.5)
	  (node-rotation-set! test-node2 45)


	  (node-pivot-x-set! test-node3 1)
	  (node-pivot-y-set! test-node3 1)
	  (node-x-set! test-node3 960)
	  (node-y-set! test-node3 540)
	  (node-scale-set! test-node3 0.5)
	  (node-rotation-set! test-node3 0)
	  ))
      (let ([root (make-root-node 1920 1080)])
	(node-add! root test-node1)
	(node-add! root test-node2)
	(node-add! root test-node3)
	(let loop ([time (GetTime)])
	  (unless (WindowShouldClose)
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
	    (loop (GetTime)))))
      (CloseAudioDevice)
      (CloseWindow)))
  )

