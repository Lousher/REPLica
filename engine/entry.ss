(library (engine entry)
  (export replica)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (scene node)
	  (scene renderer)
	  (engine resource)
	  (engine animation)
	  (engine event)
	  (engine state)
	  (engine easing) ;test
	  )
					; Manually Control FPS, raylib got some issues
  (define FPS 60)
  (define FRAME_TARGET_TIME (/ 1.0 FPS))
  (define *current-manager* (make-parameter #f))

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

  (define run-script
    (lambda (game)
      (let ([rm (*current-manager*)])
	(case (state-pc game)
	  [(0)
	   (let ([root (state-root game)])
	     (let ([tex-node1 (make-texture-node rm 1 "t1")])
	       (node-x-set! tex-node1 500)
	       (node-y-set! tex-node1 500)
	       (node-scale-set! tex-node1 0.5)
	       (node-add! root tex-node1)))
	   (state-pc-set! game 1)]
	  [(1)
	   (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	     (state-pc-set! game 2))]
	  [(2)
	   (let ([root (state-root game)])
	     (let ([char-node1 (make-char-node rm 4 "xiaolai" #\A)]
		   [char-node2 (make-char-node rm 5 "xiaolai" #\g)]
		   [char-node3 (make-char-node rm 6 "xiaolai" #\y)]
		   [char-node4 (make-char-node rm 7 "xiaolai" #\j)]
		   [char-node5 (make-char-node rm 8 "xiaolai" #\p)]
		   [char-node6 (make-char-node rm 9 "xiaolai" #\q)]
		   [char-node7 (make-char-node rm 10 "xiaolai" #\好)]
		   [char-node8 (make-char-node rm 11 "xiaolai" #\啊)])
	       (let ([text-node1
		      (make-text-node
		       12
		       (list char-node1 char-node2 char-node3 char-node4 char-node5 char-node6 char-node7 char-node8) 10)])
		 (node-x-set! text-node1 100)
		 (node-y-set! text-node1 200)
		 (node-scale-set! text-node1 0.5)
		 (node-add! root text-node1)
		 )))
	   (state-pc-set! game 3)]
	  [(3) (void)]
	  ))))

  (define replica
    (lambda (case-fn)
      (InitWindow 1920 1080 "REPLica Engine")
      (InitAudioDevice)
      (init-renderer "sdf.fs")
      (parameterize ([*current-manager* (make-manager)])
	(mount (*current-manager*) "test.rpk")
	(let* ([root (make-root-node 1920 1080)]
	       [game (make-state root)]
	       [case-ready (case-fn (*current-manager*))])
	  (let loop ([time (GetTime)])
	    (unless (WindowShouldClose)
	      (loader-update! (*current-manager*))
	      (animations-update!)
	      (clear-interact-regions!)
	      (case-ready game)
	      (BeginDrawing)
	      (ClearBackground BLACK)
	      (render root)
	      (events-update!)
	      (EndDrawing)
	      (fps-control time)	; FPS control
	      (loop (GetTime))))))
      (uninit-renderer)
      (CloseAudioDevice)
      (CloseWindow))
    )

  )
