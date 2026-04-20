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
	  (rpl runtime)
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

  (define replica
    (lambda (stage-fn)
      (InitWindow 1920 1080 "REPLica Engine")
      (InitAudioDevice)
      (init-renderer "sdf.fs")
      (parameterize ([*current-manager* (make-manager)])
	(mount (*current-manager*) "test.rpk")
	(let* ([root (make-root-node 1920 1080)]
	       [game (make-state root)]
	       )
	  (let loop ([time (GetTime)])
	    (unless (WindowShouldClose)
	      (loader-update! (*current-manager*))
	      (animations-update!)
	      (clear-interact-regions!)
	      (stage-fn game)
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
