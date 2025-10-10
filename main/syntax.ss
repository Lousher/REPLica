(define-syntax with-fullscreen
  (syntax-rules ()
    [(_ title rest ...)
     (let ([w (GetScreenWidth)]
	   [h (GetScreenHeight)]
	   [flags (logor FLAG_WINDOW_MAXIMIZED
			 FLAG_WINDOW_MINIMIZED
			 FLAG_WINDOW_RESIZABLE)])
       (SetConfigFlags flags)
       (SetTargetFPS 60)
       (InitWindow w h title)
       (InitAudioDevice)
       rest ...
       (CloseAudioDevice)
       (CloseWindow))]))

(define-syntax drawing-loop
  (syntax-rules ()
    [(_ [updating ...] [drawing ...] [cleanup ...])
     (dynamic-wind
       (lambda () #f)
       (lambda ()
	 (let loop ()
	   updating ...
	   (unless (WindowShouldClose)
	     (BeginDrawing)
	     (ClearBackground BLACK)
	     drawing ...
	     (EndDrawing)
	     (loop))))
       (lambda ()
	 cleanup ...))]))

(define-syntax asset
  (lambda (stx)
    (syntax-case stx ()
      [(_ name (diff path) ...)
       (let ([saved #f])
	 (with-syntax ([slot (datum->syntax #'name 'saved)])
	   #'(define-syntax name
	       (make-variable-transformer
		(lambda (x)
		  (syntax-case x (diff ...)
		    [id (identifier? #'id) #'slot]
		    [(id) (identifier? #'id) #'(set! slot #f)]
		    [(set! id new) (identifier? #'id) #'(set! slot new)]
		    [(_ diff) #'path] ...))))))])))

(define ASSETS (make-hashtable string-hash string=?))

(define asset-cache
  (lambda (path)
    (if (hashtable-contains? ASSETS path)
	(hashtable-ref ASSETS path 'NULL)
	(let* ([img (LoadImage path)]
	       [_ (ImageResize img (GetScreenWidth) (GetScreenHeight))]
	       [tex (LoadTextureFromImage img)])
	  (UnloadImage img)
	  (hashtable-set! ASSETS path tex)
	  (asset-cache path)))))

(define asset-clear
  (lambda (path)
    (when (hashtable-contains? ASSETS path)
      (UnloadTexture (asset-cache path))
      (hashtable-delete! ASSETS path))))
	  
(define-syntax texture
  (lambda (stx)
    (syntax-case stx ()
      [(_ name (diff path) ...)
       #'(define-syntax name
	   (make-variable-transformer
	    (lambda (x)
	      (syntax-case x (diff ...)
		[(id) #'(begin (asset-clear path) ...)]
		[(_ diff) #'(asset-cache path)] ...))))])))
