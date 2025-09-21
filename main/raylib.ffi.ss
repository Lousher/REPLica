(define-syntax define-ffi
  (syntax-rules ()
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
(define-ftype Image
  (struct
    [data void*]
    [width int]
    [height int]
    [mipmaps int]
    [format int]))

(define-ftype Texture
  (struct
    [id unsigned-int]
    [width int]
    [height int]
    [mipmaps int]
    [format int]))

(alias Texture2D Texture)

(define-ftype Color
  (struct
    [r unsigned-8]
    [g unsigned-8]
    [b unsigned-8]
    [a unsigned-8]))

					; Init related
(define-ffi GetMonitorWidth (int) int)
(define-ffi GetMonitorHeight (int) int)
(define-ffi SetConfigFlags (unsigned-int) void)
(define-ffi InitWindow (int int string) void)
(define-ffi SetTargetFPS (int) void)
(define-ffi WindowShouldClose () boolean)
(define-ffi CloseWindow () void)

					; Drawing
(define-ffi BeginDrawing () void)
(define-ffi EndDrawing () void)
(define-ffi DrawTexture ((& Texture2D) int int (& Color)) void)
(define-ffi UnloadTexture ((& Texture2D)) void)
(define-ffi ClearBackground ((& Color)) void)

					; Predicate
(define-ffi IsWindowReady () boolean)

					; Logging
(define-ffi TraceLog (int string) void)


					; Image
(define-ffi LoadImage (string) (& Image))
(define-ffi LoadTextureFromImage ((& Image)) (& Texture2D))

(define-ffi UnloadImage ((& Image)) void)

					; Extension
(define make-color
  (lambda (r g b a)
    (let* ([size (ftype-sizeof Color)]
	   [addr (foreign-alloc size)]
	   [fptr (make-ftype-pointer Color addr)])
      (ftype-set! Color (r) fptr r)
      (ftype-set! Color (g) fptr g)
      (ftype-set! Color (b) fptr b)
      (ftype-set! Color (a) fptr a)
      fptr)))


