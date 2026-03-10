(library-directories "main/")
(import (vm bundle) (raylib ffi) (raylib constant))

; if exists
#|(pack "tests/test.pak"
      '(("yuan" "assets/picture/yuan.png")
	("xin" "assets/picture/xin.png")
	("thud" "assets/sound/thud.mp3")
	("trip" "assets/bgm/midnight-trip.mp3")
	)) |#

(InitWindow 0 0 "Replica Bundle Test")
(InitAudioDevice)
(define b (mount "tests/test.pak"))

(define thud-wav (call-with-values
		     (lambda () (ref b "thud"))
		   (lambda (x y z)
		   ;  (lock-object y)
		     (LoadWaveFromMemory x y z))))
(define thud-sound (LoadSoundFromWave thud-wav))
(define trip-music (call-with-values
		       (lambda () (ref b "trip"))
		     (lambda (x y z)
		       (lock-object y)
		       (LoadMusicStreamFromMemory x y z))))
(UnloadWave thud-wav)

(define img (call-with-values
		(lambda () (ref b "yuan"))
	      (lambda (x y z)
		;(lock-object y)
		(LoadImageFromMemory x y z))))
(define tex (LoadTextureFromImage img))
(UnloadImage img)

(PlaySound thud-sound)
(PlayMusicStream trip-music)
(let loop ()
  (unless (WindowShouldClose)
    (UpdateMusicStream trip-music)
    (BeginDrawing)
    (ClearBackground BLACK)

    ;; 绘制从 RPK 提取出来的纹理
    (DrawTexture tex 0 0 WHITE)
    
    (DrawText "Resource loaded from: assets.rpk" 20 560 20 WHITE)
    ;(DrawText (format "ID: su_yu_wen | Size: ~a" (caddr )) 20 530 16 RED)
    
    (EndDrawing)
    (loop)))
(UnloadTexture tex)
(UnloadSound thud-sound)
(UnloadMusicStream trip-music)
(CloseAudioDevice)
(CloseWindow)


