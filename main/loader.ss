(library (loader)
  (export resource-guardian background visual-resource visual-color picture)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant))

  (define resource-guardian (make-guardian))

  (define-record-type visual
    (fields resource source destination origin rotation color))
  
  (define-syntax background
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let ([img (LoadImage path)])
	   (ImageResize img (GetScreenWidth) (GetScreenHeight))
	   (let ([tex (LoadTextureFromImage img)])
	     (resource-guardian tex)
	     (UnloadImage img)
	     (make-visual tex 'src 'dest 'origin 'rotation WHITE))))]))

  (define-syntax picture
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let ([tex (LoadTexture path)])
	   (resource-guardian tex)
	   (make-visual tex 'src 'dest 'ori 'rot WHITE)))]))

  )
