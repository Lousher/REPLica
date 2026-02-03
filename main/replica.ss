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
	    FLAG_WINDOW_HIGHDPI
	    FLAG_BORDERLESS_WINDOWED_MODE
	    FLAG_WINDOW_UNDECORATED
	    ;FLAG_WINDOW_RESIZABLE
	    ))
	  (InitWindow 1920 1080 "YeYuan")
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
			(stepper (cdr rest) new-state (+ 1 frame-count))]
		       ))]))))))
	(lambda ()
	  (replica-collect)
	  (CloseAudioDevice)
	  (CloseWindow))))
    )
)
