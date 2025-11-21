(library (tool)
  (export reads format-green extract-strings alist-update format-red load-texture-from-screen)
  (import (chezscheme)
	  (raylib ffi))

  (define load-texture-from-screen
    (lambda ()
      (let ([screen-img (LoadImageFromScreen)])
	(ImageResize screen-img (GetScreenWidth) (GetScreenHeight))
	(ImageFlipVertical screen-img)
	(let ([screen-tex (LoadTextureFromImage screen-img)])
	  (UnloadImage screen-img)
	  screen-tex))))
  
  (define alist-update
    (lambda (alist key val)
      (cons (cons key val)
	    (filter (lambda (pair) (not (eqv? key (car pair)))) alist))))
  
  (define extract-strings
    (lambda (scripts)
      (cond
       [(null? scripts) '()]
       [(string? scripts) (list scripts)]
       [(atom? scripts) '()]
       [(list? scripts)
	(append (extract-strings (car scripts))
		(extract-strings (cdr scripts)))]
       [else '()])))
  
  (define reads
    (lambda (port)
      (let ([content (read port)])
	(if (eof-object? content)
	    '()
	    (cons content (reads port))))))

  (define format-green
    (lambda (fmt-str . rest)
      (apply format (format "\x1b;[0;32m~a\x1b;[0m" fmt-str) rest)))

  (define format-red
    (lambda (fmt-str . rest)
      (apply format (format "\x1b;[0;31m~a\x1b;[0m" fmt-str) rest)))
  )
