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
       (CloseWindow)
       )]))

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

(define-syntax music
  (lambda (stx)
    (syntax-case stx (:play :stop)
      [(k :play params ...)
      #`(lambda (funs)
	  (let ([play-fun (cadr (assoc ':play funs))])
	    (play-fun params ...)))])))
	  
(define-syntax scene
  (lambda (stx)
    (syntax-case stx ()
      [(k params ...)
       (let ([frame-keys '(:location :characters :text)]
	     [play-keys '(:voice)]
	     [shader-keys '(:transition)]
	     [param-pairs (parse-params (syntax->datum #'(params ...)))])
	 (with-syntax ([(play-funs ...) (datum->syntax #'k (map (lambda (key) (assoc key param-pairs)) play-keys))]
		       [(render-funs ...) (datum->syntax #'k (map (lambda (key) (assoc key param-pairs)) frame-keys))]
		       [(shader-funs ...) (datum->syntax #'k (map (lambda (key) (assoc key param-pairs)) shader-keys))]
		       [(all-key ...) (datum->syntax #'k (append frame-keys play-keys shader-keys))])
	   #`(lambda (funcs)
	       (let ([all-key (cadr (assoc 'all-key funcs))] ...)
		 (begin
		   play-funs ...
		   (lambda ()
		     render-funs ...))))
	   ))])))

