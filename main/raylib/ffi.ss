(library (raylib ffi)
  (export ffi-collect ffi-guardian make-Rectangle make-Vector2 make-Color Rectangle-x Rectangle-y Rectangle-width Rectangle-height Rectangle-x-set! Rectangle-y-set! Rectangle-width-set! Rectangle-height-set! Vector2-x-set! Vector2-y-set! make-Camera2D init-Camera2D Camera2D-offset-set! Camera2D-target-set! Camera2D-rotation-set! Camera2D-zoom-set! reset-Camera2D camera-2d->Camera2D GetMonitorWidth GetMonitorHeight GetScreenWidth GetScreenHeight SetConfigFlags InitWindow SetTargetFPS WindowShouldClose CloseWindow GetTime GetFrameTime Fade BeginDrawing EndDrawing DrawTexture DrawTexturePro DrawTextureV DrawTextureRec UnloadTexture UnloadRenderTexture ClearBackground LoadRenderTexture BeginTextureMode EndTextureMode DrawRectangle DrawRectangleRec DrawRectangleV DrawRectangleRounded DrawRectangleRoundedLinesEx SetTextureFilter GenTextureMipmaps BeginShaderMode EndShaderMode LoadShader UnloadShader GetShaderLocation SetShaderValue SetShaderValueTexture LoadFileData UnloadFileData IsWindowReady SetWindowSize LoadImage LoadImageFromTexture ImageFlipVertical ImageFlipHorizontal LoadImageFromScreen LoadTextureFromImage LoadTexture UnloadImage ImageResize IsMouseButtonPressed IsMouseButtonDown IsMouseButtonReleased IsMouseButtonUp IsKeyPressed IsKeyPressedRepeat IsKeyDown IsKeyReleased IsKeyUp GetKeyPressed GetCharPressed InitAudioDevice CloseAudioDevice LoadSound UnloadSound PlaySound StopSound PauseSound ResumeSound IsSoundPlaying SetSoundPan SetSoundVolume SetSoundPitch LoadMusicStream UnloadMusicStream PlayMusicStream UpdateMusicStream StopMusicStream SetMusicVolume IsMusicStreamPlaying DrawTextCodepoints DrawText LoadFileText LoadCodepoints LoadFontEx LoadFontFromMemory LoadFont UnloadFileText UnloadCodepoints UnloadFont DrawTextEx TextSubtext GetCodepointCount MeasureTextEx BeginMode2D EndMode2D TraceLog IsTextureValid ExportImage RenderTexture-texture Texture-width Texture-height)
  (import (chezscheme)
	  (tool))

  (define _init
    (case (machine-type)
      [(tarm64osx) (load-shared-object "libraylib.5.5.0.dylib")]))
  					; syntax Extension
  (define ffi-guardian (make-guardian))

  (define ffi-collect
    (lambda ()
      (let loop ()
	(let ([res (ffi-guardian)])
	  (when res
	    (TraceLog 3 (format-green "Free Allocated Pointer ~a" res))
	    (foreign-free (ftype-pointer-address res))
	    (loop))))))
  
  (define-syntax define-ffi
    (lambda (stx)
      (syntax-case stx (&)
	[(_ name (param-type ...) (& ret-type))
	 (with-syntax ([(arg ...) (generate-temporaries #'(param-type ...))])
	   #'(define name
	       (let ([proc (foreign-procedure #f (symbol->string 'name) (param-type ...) (& ret-type))])
		 (lambda (arg ...)
		   (let ([ret-result (make-ftype-pointer ret-type (foreign-alloc (ftype-sizeof ret-type)))])
		     (ffi-guardian ret-result)
		     (proc ret-result arg ...)
		     ret-result)))))]
	[(_ name (param-type ...) ret-type)
	 #'(define name
	     (foreign-procedure #f (symbol->string 'name) (param-type ...) ret-type))])))
					; Struct
  (define-syntax define-ftype-ex
    (lambda (stx)
      (syntax-case stx (struct)
	[(_ name (struct [field-name field-type] ...))
	 (with-syntax ([make-name (datum->syntax #'name (string->symbol (format "make-~a" (symbol->string (syntax->datum #'name)))))])
	   #`(begin
	       (define-ftype name
		 (struct [field-name field-type] ...))
	       (define make-name
		 (lambda (field-name ...)
		   (let* ([size (ftype-sizeof name)]
			  [addr (foreign-alloc size)]
			  [fptr (make-ftype-pointer name addr)])
		     (ftype-set! name (field-name) fptr field-name) ...
		     fptr)))
	       #,@(map
		   (lambda (stx)
		     (with-syntax ([ref-name (datum->syntax #'name (string->symbol (format "~a-~a" (syntax->datum #'name) (syntax->datum stx))))])
		       #`(define ref-name (lambda (_) (ftype-ref name (#,stx) _)))))
		   #'(field-name ...))))])))

  (define-ftype-ex Image
    (struct
      [data void*]
      [width int]
      [height int]
      [mipmaps int]
      [format int]))
  (define-ftype-ex Texture
    (struct
      [id unsigned-int]
      [width int]
      [height int]
      [mipmaps int]
      [format int]))
  (alias Texture2D Texture)
  (define-ftype-ex Color
    (struct
      [r unsigned-8]
      [g unsigned-8]
      [b unsigned-8]
      [a unsigned-8]))
  (define-ftype-ex Rectangle
    (struct
      [x float]
      [y float]
      [width float]
      [height float]))
  (define-ftype-ex Vector2
    (struct
      [x float]
      [y float]))

  (define Rectangle-x-set!
    (lambda (rect updated)
      (ftype-set! Rectangle (x) rect updated)))

  (define Rectangle-y-set!
    (lambda (rect updated)
      (ftype-set! Rectangle (y) rect updated)))

  (define Rectangle-width-set!
    (lambda (rect updated)
      (ftype-set! Rectangle (width) rect updated)))

  (define Rectangle-height-set!
    (lambda (rect updated)
      (ftype-set! Rectangle (height) rect updated)))

  (define Vector2-x-set!
    (lambda (vec updated)
      (ftype-set! Vector2 (x) vec updated)))

  (define Vector2-y-set!
    (lambda (vec updated)
      (ftype-set! Vector2 (y) vec updated)))

					; nested complex structure
  (define-ftype RenderTexture
    (struct
      [id unsigned-int]
      [texture Texture]
      [depth Texture]))

  (alias RenderTexture2D RenderTexture)

  (define-ftype AudioStream
    (struct
      [buffer void*]
      [processor void*]
      [sampleRate unsigned-int]
      [sampleSize unsigned-int]
      [channels unsigned-int]))

  (define-ftype Sound
    (struct
      [stream AudioStream]
      [frameCount unsigned-int]))

  (define-ftype Music
    (struct
      [stream AudioStream]
      [frameCount unsigned-int]
      [looping boolean]
      [ctxType int]
      [ctxData void*]))

  (define-ftype Shader
    (struct
      [id unsigned-int]
      [locs (* int)]))

  (define-ftype Font
    (struct
      [baseSize int]
      [glyphCount int]
      [glyphPadding int]
      [texture Texture2D]
      [recs void*]
      [glyphs void*]))

  (define-ftype Camera2D
    (struct
      [offset Vector2]
      [target Vector2]
      [rotation float]
      [zoom float]))

  (define make-Camera2D
    (lambda (o t r z)
      (camera-2d->Camera2D (make-camera-2d o t r z))))

  (define-record-type camera-2d
    (fields offset target rotation zoom))

  (define init-Camera2D
    (lambda ()
      (make-Camera2D
       '(0.0 . 0.0) '(0.0 . 0.0) 0.0 1.0)))

  (define Camera2D-offset-set!
    (lambda (camera2d vec)
      (ftype-set! Camera2D (offset x) camera2d (car vec))
      (ftype-set! Camera2D (offset y) camera2d (cdr vec))))

  (define Camera2D-target-set!
    (lambda (camera2d vec)
      (ftype-set! Camera2D (target x) camera2d (car vec))
      (ftype-set! Camera2D (target y) camera2d (cdr vec))))

  (define Camera2D-rotation-set!
    (lambda (camera2d r)
      (ftype-set! Camera2D (rotation) camera2d r)))

  (define Camera2D-zoom-set!
    (lambda (camera2d z)
      (ftype-set! Camera2D (zoom) camera2d z)))

  (define reset-Camera2D
    (lambda (camera)
      (Camera2D-offset-set! camera '(0.0 . 0.0))
      (Camera2D-target-set! camera '(0.0 . 0.0))
      (Camera2D-rotation-set! camera 0.0)
      (Camera2D-zoom-set! camera 0.0)))
  
  (define camera-2d->Camera2D
    (lambda (camera)
      (let* ([size (ftype-sizeof Camera2D)]
	     [addr (foreign-alloc size)]
	     [fptr (make-ftype-pointer Camera2D addr)])
	(ftype-set! Camera2D (offset x) fptr (car (camera-2d-offset camera)))
	(ftype-set! Camera2D (offset y) fptr (cdr (camera-2d-offset camera)))
	(ftype-set! Camera2D (target x) fptr (car (camera-2d-target camera)))
	(ftype-set! Camera2D (target y) fptr (cdr (camera-2d-target camera)))
	(ftype-set! Camera2D (rotation) fptr (camera-2d-rotation camera))
	(ftype-set! Camera2D (zoom) fptr (camera-2d-zoom camera))
	fptr)))

					; Init related
  (define-ffi GetMonitorWidth (int) int)
  (define-ffi GetMonitorHeight (int) int)
  (define-ffi GetScreenWidth () int)
  (define-ffi GetScreenHeight () int)
  (define-ffi SetConfigFlags (unsigned-int) void)
  (define-ffi InitWindow (int int string) void)
  (define-ffi SetTargetFPS (int) void)         
  (define-ffi WindowShouldClose () boolean)
  (define-ffi CloseWindow () void)

					; Time
  (define-ffi GetTime () double)
  (define-ffi GetFrameTime () float)

					;Color
  (define-ffi Fade ((& Color) float) (& Color))

					; Drawing
  (define-ffi BeginDrawing () void)
  (define-ffi EndDrawing () void)
  (define-ffi DrawTexture ((& Texture2D) int int (& Color)) void)
  (define-ffi DrawTexturePro ((& Texture2D) (& Rectangle) (& Rectangle) (& Vector2) float (& Color)) void)
  (define-ffi DrawTextureV ((& Texture2D) (& Vector2) (& Color)) void)
  (define-ffi DrawTextureRec ((& Texture2D) (& Rectangle) (& Vector2) (& Color)) void)
  (define-ffi UnloadTexture ((& Texture2D)) void)
  (define-ffi UnloadRenderTexture ((& RenderTexture2D)) void)
  (define-ffi ClearBackground ((& Color)) void)
  (define-ffi LoadRenderTexture (int int) (& RenderTexture2D))
  (define-ffi BeginTextureMode ((& RenderTexture2D)) void)
  (define-ffi EndTextureMode () void)
  (define-ffi DrawRectangle (int int int int (& Color)) void)
  (define-ffi DrawRectangleRec ((& Rectangle) (& Color)) void)
  (define-ffi DrawRectangleV ((& Vector2) (& Vector2) (& Color)) void)
  (define-ffi DrawRectangleRounded ((& Rectangle) float int (& Color)) void)
  (define-ffi DrawRectangleRoundedLinesEx ((& Rectangle) float int float (& Color)) void)
  (define-ffi SetTextureFilter ((& Texture2D) int) void)
  (define-ffi GenTextureMipmaps ((* Texture2D)) void)

					; Shader
  (define-ffi BeginShaderMode ((& Shader)) void)
  (define-ffi EndShaderMode () void)
  (define-ffi LoadShader (string string) (& Shader))
  (define-ffi UnloadShader ((& Shader)) void)
  (define-ffi GetShaderLocation ((& Shader) string) int)
  (define-ffi SetShaderValue ((& Shader) int void* int) void)
  (define-ffi SetShaderValueTexture ((& Shader) int (& Texture2D)) void)

  ;; File data
  (define-ffi LoadFileData (string (* int)) (* char))
  (define-ffi UnloadFileData ((* char)) void)

					; Predicate
  (define-ffi IsWindowReady () boolean)
  (define-ffi SetWindowSize (int int) void)

					; Logging
  (define-ffi TraceLog (int string) void)


					; Image
  (define-ffi LoadImage (string) (& Image))
  (define-ffi LoadImageFromTexture ((& Texture2D)) (& Image))
  (define-ffi ImageFlipVertical ((* Image)) void)
  (define-ffi ImageFlipHorizontal ((* Image)) void)
  (define-ffi LoadImageFromScreen () (& Image))
  (define-ffi LoadTextureFromImage ((& Image)) (& Texture2D))
  (define-ffi LoadTexture (string) (& Texture2D))

  (define-ffi UnloadImage ((& Image)) void)
  (define-ffi ImageResize ((* Image) int int) void)

  ;; Event Handling
  (define-ffi IsMouseButtonPressed (int) boolean)
  (define-ffi IsMouseButtonDown (int) boolean)
  (define-ffi IsMouseButtonReleased (int) boolean)
  (define-ffi IsMouseButtonUp (int) boolean)

  (define-ffi IsKeyPressed (int) boolean)
  (define-ffi IsKeyPressedRepeat (int) boolean)
  (define-ffi IsKeyDown (int) boolean)
  (define-ffi IsKeyReleased (int) boolean)
  (define-ffi IsKeyUp (int) boolean)
  (define-ffi GetKeyPressed () int)
  (define-ffi GetCharPressed () int)

  ;; Sound
  (define-ffi InitAudioDevice () void)
  (define-ffi CloseAudioDevice () void)
  (define-ffi LoadSound (string) (& Sound))
  (define-ffi UnloadSound ((& Sound)) void)
  (define-ffi PlaySound ((& Sound)) void)
  (define-ffi StopSound ((& Sound)) void)
  (define-ffi PauseSound ((& Sound)) void)
  (define-ffi ResumeSound ((& Sound)) void)
  (define-ffi IsSoundPlaying ((& Sound)) boolean)
  (define-ffi SetSoundPan ((& Sound) float) void)
  (define-ffi SetSoundVolume ((& Sound) float) void)
  (define-ffi SetSoundPitch ((& Sound) float) void)


  ;; Music
  (define-ffi LoadMusicStream (string) (& Music))
  (define-ffi UnloadMusicStream ((& Music)) void)
  (define-ffi PlayMusicStream ((& Music)) void)
  (define-ffi UpdateMusicStream ((& Music)) void)
  (define-ffi StopMusicStream ((& Music)) void)
  (define-ffi SetMusicVolume ((& Music) float) void)
  (define-ffi IsMusicStreamPlaying ((& Music)) boolean)

					; Text
  (define-ffi DrawTextCodepoints ((& Font) (* int) int (& Vector2) float float (& Color)) void)
  (define-ffi DrawText (string int int int (& Color)) void)
  (define-ffi LoadFileText (string) (* char))
  (define-ffi LoadCodepoints (string (* int)) (* int))
  (define-ffi LoadFontEx (string int (* int) int) (& Font))
  (define-ffi LoadFontFromMemory (string (* char) int int (* int) int) (& Font))
  (define-ffi LoadFont (string) (& Font))
  (define-ffi UnloadFileText ((* char)) void)
  (define-ffi UnloadCodepoints ((* int)) void)
  (define-ffi UnloadFont ((& Font)) void)
  (define-ffi DrawTextEx ((& Font) string (& Vector2) float float (& Color)) void)
  (define-ffi TextSubtext (string int int) string)
  (define-ffi GetCodepointCount (string) int)
  (define-ffi MeasureTextEx ((& Font) string float float) (& Vector2))
  ;;Camera
  (define-ffi BeginMode2D ((& Camera2D)) void)
  (define-ffi EndMode2D () void)

  ;;Validator
  (define-ffi IsTextureValid ((& Texture2D)) boolean)

  ;; Exporter
  (define-ffi ExportImage ((& Image) string) boolean)

  ;; Custome Extension
  (define RenderTexture-texture
    (lambda (fptr)
      (ftype-&ref RenderTexture (texture) fptr)))

  )
