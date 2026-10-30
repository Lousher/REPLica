(library (game engine)
  (export start)
  (import (chezscheme)
	  (ffi raylib binding)
	  (ffi rini binding))


  (define c (make-ftype-pointer Color (foreign-alloc (ftype-sizeof Color))))
  
  (define tex #f)
  (define mus #f)
  
  (define start
    (lambda (config)
      (ftype-set! Color (r) c 255)
      (ftype-set! Color (g) c 255)
      (ftype-set! Color (b) c 255)
      (ftype-set! Color (a) c 255)

      (let* ([ini-cfg (rini_load config)]
	     [title (rini_get_value_text ini-cfg "title")]
	     [w (rini_get_value ini-cfg "width")]
	     [h (rini_get_value ini-cfg "height")]
	     [vol (rini_get_value ini-cfg "master_volume")])
	(InitWindow w h title)
	(InitAudioDevice)
	(set! tex (LoadTexture "store/asset/store/apartment.morning.png"))
	(set! mus (LoadMusicStream "store/asset/store/piano.mp3"))
	(SetMusicVolume mus (inexact (/ vol 100)))
	(PlayMusicStream mus)
	(let loop ()
	  (unless (WindowShouldClose)
	    (UpdateMusicStream mus)
	    (BeginDrawing)
	    (ClearBackground c)
	    (DrawTexture tex 0 0 c)
	    (EndDrawing)
	    (loop)))
	(UnloadTexture tex)
	(CloseAudioDevice)
	(CloseWindow))))
  )
