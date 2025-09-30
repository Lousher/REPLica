(define-syntax with-fullscreen
  (syntax-rules ()
    [(_ title rest ...)
     (let ([w (GetMonitorWidth 0)]
	   [h (GetMonitorHeight 0)]
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


(define :id? (lambda (id) (and (symbol? id) (char=? #\: (string-ref (symbol->string id) 0)))))
(define parse-params
  (lambda (params)
    (fold-left
     (lambda (acc next)
       (if (:id? next)
	   (append acc (list (list next)))
	   (let ([last (last-pair acc)])
	     (set-cdr! (car last) (append (cdar last) (list next)))
	     acc)))
     '()
     params)))

(define symbol-format
  (lambda (fmt-str . rest)
    (let* ([strs (map symbol->string rest)]
	   [outcome (apply format fmt-str strs)])
      (string->symbol outcome))))

(define-syntax scene
  (lambda (stx)
    (syntax-case stx ()
      [(k params ...)
       (let ([frame-keys '(:location :characters :text)]
	     [play-keys '(:voice)]
	     [param-pairs (parse-params (syntax->datum #'(params ...)))])
	 (with-syntax ([(play-funs ...) (datum->syntax #'k (map (lambda (key) (let ([res (assoc key param-pairs)])
										(set-car! res (symbol-format "play~a" key))
										res))
								play-keys))]
		       [(render-funs ...)
			(datum->syntax #'k (map (lambda (key)
						  (let ([res (assoc key param-pairs)])
						    (set-car! res (symbol-format "render~a" key))
						    res))
						frame-keys))])
	   #'(begin
	       play-funs ...
	       (lambda ()
	       render-funs ...))
	   ))])))

(define-syntax read-scene
  (lambda (x)
    (syntax-case x (scene)
      [(k (scene args ...))
       (let ([script (datum (scene args ...))])
         (datum->syntax #'k script))])))
