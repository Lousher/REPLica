(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (design color))

(import (ffi raylib binding))

(define main
  (lambda ()
    (InitWindow 960 540 "Test")
    (InitAudioDevice)
    (SetTargetFPS 60)
    (let ([mus (LoadMusicStream "test/store/trip.mp3")]	   
	  [BLANK (color->Color blank)]
	  )
      (PlayMusicStream mus)
      (let loop ()
	(unless (WindowShouldClose)
	  (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (let ([time (GetMusicTimePlayed mus)])
	      (SeekMusicStream mus (+ time 10))))
	  (UpdateMusicStream mus)
	  (BeginDrawing)
	  (ClearBackground BLANK)
	  
	  (EndDrawing)
	  (loop))
	)
      (UnloadMusicStream mus))
    (CloseAudioDevice)
    (CloseWindow)))

(main)
