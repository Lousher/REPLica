(load-shared-object "ffi/raylib/libraylib.so.6.0.0")

(import (core type))
(import (core frame))
(import (core picture))
(import (core animator))
(import (prefix (core rate) rate:))
(import (design color))
(import (core easing))

(import (ffi raylib binding))

(define main
  (lambda ()
    (SetConfigFlags FLAG_MSAA_4X_HINT)
    (InitWindow 1920 1080 "Test")

    (SetTargetFPS 60)
    (let* ([tex (LoadTexture "test/store/apartment.morning.png")]
	   [tex2 (LoadTexture "test/store/apartment.afternoon.png")]
	   [paper-img (GenImageColor 764 1080 (color->Color (make-color 240 238 230 255)))]
	   [paper-tex (LoadTextureFromImage paper-img)]
	   [tex-in (make-texture "morning" tex)]
	   [tex2-in (make-texture "afternoon" tex2)]
	   [paper-tex-in (make-texture "paper" paper-tex)]
	   [noise-tex (make-perlin-noise-texture 256 256 0 0 3.0)]
	   [noise-tex2 (make-perlin-noise-texture 256 256 0 0 8.0)]
	   [pic (texture->picture tex-in)]
	   [pic2 (texture->picture tex2-in)]
	   [noise-pic (texture->picture noise-tex)]
	   [noise-pic2 (texture->picture noise-tex2)]
	   [paper-pic
	    (layer
	     (stroke (texture->picture paper-tex-in) 0.5 gray)
	     (fade noise-pic 10)
	     (fade noise-pic2 10)
	     )]
	   [fr (make-frame
		1920.0
		1080.0
		(make-vector2 960.0 540.0)
		(make-vector2 960.0 540.0)
		0.0)]
	   [fr-paper
	    (make-frame
	     764.0 1080.0
	     (make-vector2 200.0 0.0)
	     (make-vector2 0.0 0.0)
	     0.0
	     )]
	   [BLANK (color->Color blank)]
	   [ani (static pic)]
	   [ani2 (static
		  (layer
		   (rotate paper-pic -1)
		   (rotate paper-pic 0.3)
		   (rotate paper-pic -0.5)
		   (rotate paper-pic 0)
		   ))]
	   )
      (UnloadImage paper-img)
      (let loop ([a ani])
	(unless (WindowShouldClose)
	  (parameterize ([*PASSED* (GetTime)])
	    (BeginDrawing)
	    (ClearBackground BLANK)
	    (a fr)
	    (ani2 fr-paper)
	    (EndDrawing)
	    (loop a)))
	)
      (UnloadTexture tex))
    (CloseWindow)))

(main)
