(library (replica)
  (export replica *actions*)
  (import (chezscheme)
	  (transpiler)
	  (state)
	  (loader)
	  (tool)
	  (raylib ffi)
	  (raylib constant))

  (define *actions* (make-parameter #f))

  (define chapter-history
    (lambda (texts)
      (let* ([codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
	     [codepoints (LoadCodepoints (apply string-append texts) codepoints-count)]
	     [font (LoadFontEx "assets/font/lxgw.ttf" 36 codepoints (ftype-ref int () codepoints-count))]
             [pos (make-Vector2 0.0 0.0)]
             [origin (make-Vector2 0.0 0.0)]
             [shadow-color (make-Color 0 0 0 255)]
             [main-color (make-Color 255 255 255 255)])
	   (resource-guardian font)
           (resource-guardian pos)
           (resource-guardian origin)
           (resource-guardian shadow-color)
           (resource-guardian main-color)
	   (UnloadCodepoints codepoints)
	   (foreign-free (ftype-pointer-address codepoints-count))
	   (lambda (history-list)
	     (let ([scroll-offset 0.0])
	       (lambda (s)
		 (let ([wheel (GetMouseWheelMove)])
		   (unless (= wheel 0.0)
		     (set! scroll-offset (+ scroll-offset (* wheel 60.0)))
		     (when (< scroll-offset 0.0)
		       (set! scroll-offset 0.0))))
               (BeginMode2D (*viewport-camera*))
               (let loop ([lst history-list]
                          [y (+ 850.0 scroll-offset)]
                          [logic-alpha 255])
                 (unless (or (null? lst) (< y -50.0))
                   (let* ([text (car lst)]
                          [x 300.0]
                          [render-alpha (max 220 logic-alpha)])
                     (Vector2-x-set! pos (+ x 2.0))
                     (Vector2-y-set! pos (+ y 2.0))
                     (DrawTextPro font text pos origin 0.0 50.0 5.0 shadow-color)
                     ;; 2. 画主文字
                     (ftype-set! Color (a) main-color render-alpha)
                     (Vector2-x-set! pos x)
                     (Vector2-y-set! pos y)
                     (DrawTextPro font text pos origin 0.0 50.0 5.0 main-color)
                     ;; 继续画上一句：Y 往上走 80 像素，逻辑透明度降低 45
                     (loop (cdr lst) (- y 100.0) (- logic-alpha 5)))))
               ;(EndMode2D)
	       ))))))

  (define state-init
    (lambda ()
      (make-state
       (make-window 0.0 0.0 1920.0 1080.0)
       0.0)))

  (define replica-collect
    (lambda ()
      (collect 4)
      (resource-collect)
      (ffi-collect)))

  (define ensure-compiled
    (lambda (base-name)
      (let ([rpl-path (string-append base-name ".rpl")]
            [ril-path (string-append base-name ".ril")]
            [so-path  (string-append base-name ".so")])
        
        ;; 1. 检查是否需要转译 (RPL -> RIL)
        ;; 如果 .rpl 存在，且 (.ril 不存在 或 .rpl 比 .ril 新)，则转译
        (when (file-exists? rpl-path)
          (when (or (not (file-exists? ril-path))
                    (time>? (file-modification-time rpl-path)
                            (file-modification-time ril-path)))
            (TraceLog LOG_INFO (format "[Replica] Transpiling ~a -> ~a" rpl-path ril-path))
            (rpl->ril rpl-path ril-path)))

        ;; 2. 检查是否需要编译 (RIL -> SO)
        ;; 如果 .ril 存在，且 (.so 不存在 或 .ril 比 .so 新)，则编译
        (when (file-exists? ril-path)
          (when (or (not (file-exists? so-path))
                    (time>? (file-modification-time ril-path)
                            (file-modification-time so-path)))
            (TraceLog LOG_INFO (format "[Replica] Compiling ~a -> ~a" ril-path so-path))
            (compile-file ril-path))))))

  (define strip-extension
    (lambda (name)
      (let ([len (string-length name)])
        (if (and (> len 3) (string=? (substring name (- len 3) len) ".so"))
            (substring name 0 (- len 3))
            name))))
  
  (define replica
    (lambda (entry)
      (dynamic-wind
	(lambda ()
	  (SetConfigFlags
	   (logor
;	    FLAG_WINDOW_HIGHDPI
	    FLAG_BORDERLESS_WINDOWED_MODE
	    FLAG_WINDOW_MAXIMIZED
;	    FLAG_WINDOW_UNDECORATED
;	    FLAG_WINDOW_RESIZABLE
	    FLAG_WINDOW_HIDDEN
	    ))
	  (InitWindow 1 1 "YeYuan")
	  (let* ([monitor-w (GetMonitorWidth 0)]
		 [monitor-h (GetMonitorHeight 0)]
		 [scale-w (/ monitor-w 1920.0)]
		 [scale-h (/ monitor-h 1080.0)]
		 [scale (min scale-w scale-h)]
		 [win-w (* scale 1920.0)]
		 [win-h (* scale 1080.0)])
	    (*monitor-scale* scale)
	    (SetWindowPosition 0 0)
	    (SetWindowSize (flonum->fixnum win-w) (flonum->fixnum win-h))
;	    (SetWindowSize 960 540)
	    (ClearWindowState FLAG_WINDOW_HIDDEN)
	    )
	  (viewport-init)
	  (InitAudioDevice)
	  (SetTargetFPS 60))
	(lambda ()
	  (call/cc
	   (lambda (exit)
	     (let storying ([current-story (strip-extension entry)]
			    [story-state (state-init)])
	       (ensure-compiled current-story)
	       (replica-collect)
	       (load (string-append current-story ".so"))
	       (*history* (chapter-history (*text*)))
	       (*history-texts* '())
	       (let stepper ([rest (*actions*)] [step-state story-state] [frame-count 0])
		 (*actions* #f)
		 (cond
		  [(null? rest) (exit)]
		  [(list? (car rest))
		   (stepper (append (car rest) (cdr rest)) step-state frame-count)]
		  [else
		   (let-values ([(sig new-state) ((car rest) step-state)])
		     (replica-collect)
		     (TraceLog LOG_INFO (format "Sig is ~a , State is ~a" sig (state-time new-state)))
		     (case (car sig)
		       [(exit)
			(TraceLog LOG_INFO (format-red "Game Exited Successfully!"))
			(exit)]
		       [(jump)
			(TraceLog LOG_INFO "Jumping to next story!")
			(storying (cadr sig) new-state)]
		       [(next)
			(TraceLog LOG_INFO (format-green "Next Frame!"))
			(stepper (cdr rest) new-state (+ 1 frame-count))
			]
		       ))]))))))
	(lambda ()
	  (replica-collect)
	  (CloseAudioDevice)
	  (CloseWindow))))
    )
)
