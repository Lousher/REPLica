					; Syntax Extension
(define-syntax define-ffi
  (syntax-rules (&)
    [(_ name (args ...) (& ret))
     (define name
       (lambda params
	 (let ([proc (foreign-procedure #f (symbol->string 'name) (args ...) (& ret))]
	       [ret-result (make-ftype-pointer ret (foreign-alloc (ftype-sizeof ret)))])
	   (apply proc ret-result params)
	   ret-result)))]
    [(_ name (args ...) ret)
     (define name
       (foreign-procedure #f
			  (symbol->string 'name)
			  (args ...)
			  ret))]))

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
		 #'(field-name ...))
	     ))])))

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

(define-ftype Font
  (struct
    [baseSize int]
    [glyphCount int]
    [glyphPadding int]
    [texture Texture2D]
    [recs void*]
    [glyphs void*]))

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

					; Predicate
(define-ffi IsWindowReady () boolean)

					; Logging
(define-ffi TraceLog (int string) void)


					; Image
(define-ffi LoadImage (string) (& Image))
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

					; Text
(define-ffi DrawText (string int int int (& Color)) void)
(define-ffi LoadFileText (string) (* char))
(define-ffi LoadCodepoints ((* char) (* int)) (* int))
(define-ffi LoadFontEx (string int (* int) int) (& Font))
(define-ffi UnloadFileText ((* char)) void)
(define-ffi UnloadCodepoints ((* int)) void)
(define-ffi UnloadFont ((& Font)) void)
(define-ffi DrawTextEx ((& Font) string (& Vector2) float float (& Color)) void)

;; Custome Extension
(define RenderTexture-texture
  (lambda params
    (let ([fun-ori (foreign-procedure #f "RenderTexture_texture" ((& RenderTexture2D)) (& Texture2D))]
	  [result (make-ftype-pointer Texture2D (foreign-alloc (ftype-sizeof Texture2D)))])
      (apply fun-ori result params)
      result)))

