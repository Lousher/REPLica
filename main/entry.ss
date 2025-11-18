(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

(load "primitive.ss")
(load "tool.ss")

(define all-text #f)

(define :size ':size)
(define :color ':color)
(define :speed ':speed)

(define :volume ':volume)
(define :pitch ':pitch)
(define :pan ':pan)
(define :time ':time)

(define empty-fragment (lambda (state) (void)))

(define-syntax with-defaults
  (lambda (stx)
    (syntax-case stx (lambda)
      [(k defaults (lambda (arg ...) rest ...))
       (let* ([grouped (list-group (datum defaults) 2)]
	      [keys (map car grouped)]
	      [vals (map cadr grouped)])
	 (with-syntax ([((key val) ...) (datum->syntax #'k grouped)])
	   #`(let ([key val] ...)
	       (case-lambda
		 [(arg ...) rest ...]
		 [(arg ... . new)
		  (let* ([grouped-new (list-group new 2)]
			 [keys-new (map car grouped-new)])
		    (for-each
		     (lambda (p)
		       (case (car p)
			 [(key) (set! key (cadr p))] ...
			 [else (error 'with-defaults "No Such Default key" (car p))]))
		     grouped-new)
		    rest ...)]))))])))

(define play
  (with-defaults
   (:volume 1.0 :pitch 1.0 :pan 0.5 :time #f)
   (lambda (frag)
     (let ([played #f])
       (lambda (passed)
	 (when (and :time (> passed :time))
	   (frag 'x 'y))
	 (lambda (state)
	   (unless played
	     (frag state)
	     (set! played #t))))))))

(define static
  (lambda (frag)
    (lambda (passed)
      frag)))

(define parallel
  (lambda animators
    (lambda (passed)
      (lambda (state)
	(for-each
	 (lambda (animator)
	   ((animator passed) state))
	 animators)))))

(define sequential
  (lambda timelines
    (let-values ([(times animators) (partition-by-index timelines)])
      (let ([len (length animators)])
	(lambda (passed)
	  (let ([actived-times (filter (lambda (t) (>= passed t)) times)])
	    (let* ([applyed-total-times (append (cdr actived-times) (list passed))]
		   [applyed-diff-times (map (lambda (start end) (- end start)) actived-times applyed-total-times)]
		   [applyed-animators (list-head animators (length actived-times))])
	      (lambda (state)
		(for-each (lambda (animator diff-pass)
			    ((animator diff-pass) state))
			  applyed-animators applyed-diff-times)))))))))

(define-syntax preload
  (syntax-rules ()
    [(_ (type name . args) ...)
     (begin
       (define-top-level-value 'name (load-primitive 'type (quasiquote args))) ...
       (TraceLog LOG_INFO (format-green "[~a Type Primitive ~a Definied]" 'type 'name)) ...
       (lambda (state next)
	 (dynamic-wind
	   (lambda ()
	     (TraceLog LOG_INFO (format-green "Preload ~a successfully" (datum (name ...)))))
	   (lambda ()
	     (next state))
	   (lambda ()
	     (name) ...
	     (TraceLog LOG_INFO (format-green "[~a Type Primitive ~a Unload]" 'type 'name)) ...))))]))

(define lock
  (lambda (name animator)
    (let ([locked-animator (let ([total 0.0])
			     (lambda (passed)
			       (set! total (+ total (GetFrameTime)))
			       (animator total)))])
    (lambda (state next)
      (let* ([locked-part (assv ':locked state)]
	     [locked-animator-alist (cdr locked-part)])
	(set-cdr! locked-part (cons (cons name locked-animator) locked-animator-alist))
	(next state))))))

(define wait
  (lambda (animator time)
    (lambda (passed)
      (if (> passed time)
	  (animator (- passed time))
	  empty-fragment))))
    
(define unlock
  (lambda (name)
    (lambda (state next)
      (let* ([locked-part (assv ':locked state)]
	     [locked-animator-alist (cdr locked-part)])
	(set-cdr! locked-part (delv name locked-animator-alist))
	(next state)))))

(define make-directive
  (lambda (animator end?)
    (lambda (state next)
      (let animating ([passed 0.0])
	(let ([locked-part (assv ':locked state)])
	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (for-each (lambda (locked-animator-pair)
		      (((cdr locked-animator-pair) passed) state))
		    (reverse (cdr locked-part)))
	  ((animator passed) state)
	  (EndDrawing)
	  (cond
	   [(WindowShouldClose) (void)]
	   [(end? state)
	    (let* ([previous-part (assv ':previous state)]
		   [previous-texture (cdr previous-part)])
	      (when previous-texture
		(UnloadTexture previous-texture))
	      (set-cdr! previous-part (load-texture-from-screen))
	      (next state))]
	   [else
	    (animating (+ passed (GetFrameTime)))]))))))

(define normal-directive
  (lambda (animator)
    (make-directive
     animator
     (lambda (s) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))))

(define replica
  (lambda (stories)
    (InitWindow (GetScreenWidth) (GetScreenHeight) "TEST")
    (InitAudioDevice)
    (let ([state '((:previous . #f) (:locked . ()))])
      (fold-left
       (lambda (prev-state remaining-story)
	 (let* ([scripts (call-with-input-file remaining-story reads)]
		[stroy-cps (fold-right
			    (lambda (script acc-k)
			      (lambda (state)
				(let* ([directive (case (car script)
						    [(preload lock unlock) (eval script)]
						    [else (normal-directive (eval script))])])
				  (directive state acc-k))))
			    (lambda (s)
			      (TraceLog LOG_INFO (format "Final State is ~a" s))
			      (let ([previous-part (assv ':previous s)])
				(UnloadTexture (cdr previous-part))))
			    scripts)])
	   (let* ([strings (extract-strings scripts)]
		  [available-strs (filter (lambda (str) (not (file-exists? str))) strings)])
	     (fluid-let ([all-text (apply string-append available-strs)])
	       (stroy-cps prev-state)))))
       state
       stories))
    (CloseAudioDevice)
    (CloseWindow)))
