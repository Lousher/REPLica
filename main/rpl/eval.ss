(library (rpl eval)
  (export eval render)
  (import (vm bundle)
	  (raylib ffi)
	  (raylib constant)
	  (except (chezscheme) eval)
	  (rename (chezscheme) (eval c:eval)))

  #| primitive
  (mount xxx)
  (assets
   (texture xxx xxx-path))
  (show xxx) ; assume that xxx is already loaded
  |#

  (define-record-type render-command
    (fields (mutable type)
	    (mutable id)))

  (define-record-type render-context
    (fields (mutable x)
	    (mutable y)))

  (define *current-bundles* #f)
  (define *command-list* '())
    
  (define eval
    (lambda (exp env ctx)
      (case (car exp)
	[(bundle)
	 (set! *current-bundles* (mount (cadr exp)))]
	[(assets)
	 (for-each (lambda (def)
		     (let ([name (cadr def)] [path (caddr def)])
		       (hashtable-set! env name path)))
		   (cdr exp))]
	[(show)
	 (let* ([sym (cadr exp)]
		[path (hashtable-ref env sym #f)])
	   (when (and path *current-bundles*)
	     (let-values ([(ext data len) (ref *current-bundles* path)])
	       (let* ([img (LoadImageFromMemory ext data len)]
		      [tex (LoadTextureFromImage img)])
		 (UnloadImage img)
		 (set! *command-list* (cons (make-render-command 'TEXTURE tex) *command-list*))))))]
	)))

  (define render
    (lambda (scripts)
      (InitWindow 800 600 "RPL MVP")
      (let ([env (make-hashtable symbol-hash symbol=?)]
	    [ctx (make-render-context 0 0)])
	(let loop ()
	  (unless (WindowShouldClose)
	    (set! *command-list* '())
	    (for-each (lambda (exp) (eval exp env ctx)) scripts)
	    (BeginDrawing)
	    (ClearBackground WHITE)
	    (for-each (lambda (cmd)
			(case (render-command-type cmd)
			  [(TEXTURE)
			   (DrawTexture (render-command-id cmd) 0 0 WHITE)]))
		      (reverse *command-list*))
	    (EndDrawing)
	    (loop))))
      (when *current-bundles* (unmount *current-bundles*))
      (CloseWindow)
      ))
  )
