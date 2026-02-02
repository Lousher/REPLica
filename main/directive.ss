(library (directive)
  (export make-animation static background jump above beside play parallel locate duration stop trigger chain character rectangle hover-rectangle)
  (import (chezscheme)
	  (state)
	  (loader)
	  (tool)
	  (raylib ffi)
	  (raylib constant))

  (define make-animation
    (lambda (animator)
      (lambda (state)
	(letrec ([run-frame (lambda (s current previous next)
			      (for-each UpdateMusicStream (*musics*))
			      (parameterize ([*current-viewport* current]
					     [*previous-viewport* previous])
				(BeginTextureMode (*current-viewport*))
				(ClearBackground BLACK)
				(BeginMode2D (*viewport-camera*))
				(animator s)
				(EndMode2D)
				(EndTextureMode))
			      (BeginDrawing)
			      (ClearBackground BLACK)
			      (DrawTexturePro (RenderTexture-texture current) 
					      (*viewport-src*) (*viewport-dest*) (*viewport-origin*) 0.0 WHITE)
			      (EndDrawing)
			      (next s))]
		 [ping (lambda (s)
			 (run-frame s (*current-rt*) (*previous-rt*) (lambda (s)
								       (cond
									[(WindowShouldClose)
									 (values `(exit) s)]
									[#t
									 (cond
									  [(IsMouseButtonPressed MOUSE_BUTTON_LEFT)
									   (values `(next) s)]
									  [else (pong (state-time-pass s (GetFrameTime)))])]
									[else (pong (state-time-pass s (GetFrameTime)))]))))]
		 [pong (lambda (s)
			 (run-frame s (*previous-rt*) (*current-rt*) (lambda (s)
								       (cond
									[(WindowShouldClose)
									 (values `(exit) s)]
									[#t
									 (cond
									  [(IsMouseButtonPressed MOUSE_BUTTON_LEFT)
									   (values `(next) s)]
									  [else (pong (state-time-pass s (GetFrameTime)))])]
									[else (ping (state-time-pass s (GetFrameTime)))]))))])
	  (ping state)
	  ))))

  
  (define jump
    (lambda (next)
      (lambda (state)
	(values `(jump ,next) state))))
  
  (define texture->Rectangle
    (lambda (tex)
      (let ([rect (make-Rectangle 0.0 0.0 (inexact (Texture-width tex)) (inexact (Texture-height tex)))])
	(resource-guardian rect)
	rect)))

  (define window->Rectangle
    (lambda (win)
      (let ([rect (make-Rectangle (window-x win) (window-y win) (window-width win) (window-height win))])
	(resource-guardian rect)
	rect)))
  
  (define background
    (lambda (res)
      (let ([src #f] [dest (make-Rectangle 0.0 0.0 1920.0 1080.0)]
	    [origin (make-Vector2 0.0 0.0)])
	(resource-guardian origin)
	(resource-guardian dest)
	(lambda (s)
	  (let ([current-status #f] [current-data #f])
	    (with-mutex (resource-lock res)
	      (set! current-status (resource-status res))
	      (when (or (eqv? current-status 'ram-ready)
			(eqv? current-status 'gpu-ready))
		(set! current-data (resource-data res))))
	    (case current-status
	      [(loading)
	       (DrawText "Loading ..." 0 0 20 WHITE)]
	      [(error)
	       (DrawText "ERROR ..." 0 0 20 RED)]
	      [(ram-ready)
	       (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...")
	       (let ([tex (LoadTextureFromImage current-data)])
		 (SetTextureFilter tex 1)
		 (resource-guardian tex)
		 (with-mutex (resource-lock res)
		   (resource-data-set! res tex)
		   (resource-status-set! res 'gpu-ready)
		   (UnloadImage current-data)
		   (TraceLog LOG_INFO "Optimization: Background Image freed manually."))
		 )
		 ]
	      [(gpu-ready)
	       (unless src (set! src (texture->Rectangle current-data)))
	       (DrawTexturePro current-data src dest origin 0.0 WHITE)])
	    )))))

  (define character
    (lambda (res)
      (let ([src #f] [dest #f]
	    [origin (make-Vector2 0.0 0.0)])
	(resource-guardian origin)
	(lambda (s)
	  (let ([current-status #f] [current-data #f])
	    (with-mutex (resource-lock res)
	      (set! current-status (resource-status res))
	      (when (or (eqv? current-status 'ram-ready)
			(eqv? current-status 'gpu-ready))
		(set! current-data (resource-data res))))
	    (case current-status
	      [(loading)
	       (DrawText "Loading ..." 0 0 20 WHITE)]
	      [(error)
	       (DrawText "ERROR ..." 0 0 20 RED)]
	      [(ram-ready)
	       (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...")
	       (let ([tex (LoadTextureFromImage current-data)])
		 (SetTextureFilter tex 1)
		 (resource-guardian tex)
		 (with-mutex (resource-lock res)
		   (resource-data-set! res tex)
		   (resource-status-set! res 'gpu-ready)
		   (UnloadImage current-data)
		   (TraceLog LOG_INFO "Optimization: Background Image freed manually.")
		   ))]
	      [(gpu-ready)
	       (unless dest
		 (let* ([win (state-window s)]
			[logic-w (window-width win)]
			[logic-h (window-height win)]
			[tex-w (Texture-width current-data)]
			[tex-h (Texture-height current-data)]
			[scale-factor (/ logic-w tex-w)]
			[final-h (* tex-h scale-factor)]
			[pos-y (- logic-h final-h)])
		   (set! dest
			 (make-Rectangle 0.0 0.0 (inexact logic-w) (inexact final-h)))))
	       (unless src
		 (set! src (texture->Rectangle current-data)))
	       (DrawTexturePro current-data src dest origin 0.0 WHITE)])
	    )))))
  
  (define rectangle
    (lambda (x y w h)
      (let ([rect (make-Rectangle (exact->inexact x) 
                                  (exact->inexact y) 
                                  (exact->inexact w) 
                                  (exact->inexact h))])
        (resource-guardian rect)
        (lambda (s)
          (let ([vm (GetMousePosition)])
            (if (CheckCollisionPointRec vm rect)
                (DrawRectangleLines x y w h RED)
                (DrawRectangleLines x y w h BLACK)))))))

  (define hover-rectangle
    (lambda (x y w h ani-normal ani-hover)
      (let ([rect (make-Rectangle (exact->inexact x) 
                                  (exact->inexact y) 
                                  (exact->inexact w) 
                                  (exact->inexact h))])
        (resource-guardian rect)
        (lambda (s)
          (if (CheckCollisionPointRec (GetMousePosition) rect)
              (ani-hover s)
              (ani-normal s))))))
  
  (define static
    (lambda (res)
      (lambda (s)
	(let ([current-status #f] [current-data #f] [win (state-window s)])
	  (with-mutex (resource-lock res)
	    (set! current-status (resource-status res))
	    (when (or (eqv? current-status 'ram-ready)
		      (eqv? current-status 'gpu-ready))
	      (set! current-data (resource-data res))))
	  (case current-status
	    [(error)
	     (DrawText "ERROR ..." 0 0 20 RED)]
	      [(loading)
	       (DrawText "Loading ..." 0 0 20 WHITE)]
	      [(ram-ready)
	       (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...\n")
	       (let ([tex (LoadTextureFromImage current-data)])
		 (resource-guardian tex)
;		 (GenTextureMipmaps tex)
		 (SetTextureFilter tex 1)
		 (with-mutex (resource-lock res)
		   (resource-data-set! res tex)
		   (resource-status-set! res 'gpu-ready))
		 (DrawTexture tex 0 0 WHITE)
		 )]
	      [(gpu-ready)
	       (DrawTexture current-data 0 0 WHITE)])))))
  
  (define play
    (lambda (res . args)
      (let ([fade-time (if (null? args) 0.0 (car args))]
            [played #f]
            [start-time #f]
            ;; 【关键】判断资源类型
            [is-music (eq? (ftype-pointer->ftype-symbol res) 'Music)]) 
        (lambda (s)
          ;; --- 1. 首次执行：开始播放 ---
          (unless played
            (let ([start-vol (if (> fade-time 0.0) 0.0 1.0)])
              ;; 设置初始音量
              (if is-music
                  (SetMusicVolume res start-vol)
                  (SetSoundVolume res start-vol)))
            ;; 执行播放指令
            (if is-music
                (begin
                  (PlayMusicStream res)
                  ;; 【关键】如果是音乐，必须注册到活跃列表，否则没有声音
                  ;; 注意：*active-musics* 是我们在 loader.ss 里新加的 parameter
                  (let ([current-list (*musics*)])
                    (unless (member res current-list)
                      (*musics* (cons res current-list)))))
                ;; 如果是音效，直接播放
                (PlaySound res))
            
            (set! played #t)
            (when (> fade-time 0.0)
              (set! start-time (state-time s))))

          ;; --- 2. 后续帧：处理淡入效果 ---
          (when (and start-time (> fade-time 0.0))
            (let* ([elapsed (- (state-time s) start-time)]
                   [vol (if (>= elapsed fade-time) 1.0 (/ elapsed fade-time))])
              
              ;; 实时更新音量
              (if is-music
                  (SetMusicVolume res (inexact vol))
                  (SetSoundVolume res (inexact vol)))
                  
              (when (>= elapsed fade-time) 
                (set! start-time #f))))))))

  (define stop
    (lambda (res . args)
      (let ([fade-time (if (null? args) 0.0 (car args))]
            [start-time #f]
            [stopped #f]
            [is-music (eq? (ftype-pointer->ftype-symbol res) 'Music)])
        (lambda (s)
          (unless stopped
            (unless start-time (set! start-time (state-time s)))
            (let ([elapsed (- (state-time s) start-time)])
              
              (if (>= elapsed fade-time)
                  ;; --- 停止 ---
                  (begin
                    (if is-music
                        (begin
                          (StopMusicStream res)
                          ;; 【关键】从活跃列表中移除
                          (*musics* (remove res (*musics*)))
                          (SetMusicVolume res 1.0))
                        (begin
                          (StopSound res)
                          (SetSoundVolume res 1.0)))
                    (set! stopped #t))
                  
                  ;; --- 淡出 ---
                  (let ([vol (- 1.0 (/ elapsed fade-time))])
                    (if is-music
                        (SetMusicVolume res (inexact (max 0.0 vol)))
                        (SetSoundVolume res (inexact (max 0.0 vol))))))))))))

  (define above
    (lambda (ani-a ani-b factor)
      (let ([s-a #f] [s-b #f])
	(lambda (s)
	  (unless (or s-a s-b)
	    (let* ([win (state-window s)]
		   [x (window-x win)]
		   [y (window-y win)]
		   [w (window-width win)]
		   [h (window-height win)]
		   [h-a (* h factor)])
	      (set! s-a (state-copy s))
	      (window-height-set! (state-window s-a) h-a)
	      (set! s-b (state-copy s))
	      (window-y-set! (state-window s-b) (+ y h-a))
	      (window-height-set! (state-window s-b) (- h h-a))))
	  (ani-a s-a)
	  (ani-b s-b)))))

  (define beside
    (lambda (ani-a ani-b factor)
      (let ([s-a #f] [s-b #f])
	(lambda (s)
	  (unless (or s-a s-b)
	    (let* ([win (state-window s)]
		   [x (window-x win)]
		   [y (window-y win)]
		   [w (window-width win)]
		   [h (window-height win)]
		   [w-a (* w factor)])
	      (set! s-a (state-copy s))
	      (window-width-set! (state-window s-a) w-a)
	      (set! s-b (state-copy s))
	      (window-x-set! (state-window s-b) (+ x w-a))
	      (window-width-set! (state-window s-b) (- w w-a))))
	  (ani-a s-a)
	  (ani-b s-b)))))
  
  (define parallel
    (lambda anis
      (lambda (s)
	(for-each (lambda (ani) (ani s)) anis))))

  (define locate
    (lambda (ani x-factor y-factor)
      (lambda (s)
	(let* ([s-located (state-copy s)]
	       [win-located (state-window s-located)])
	  (window-x-set! win-located (* x-factor (window-width win-located)))
	  (window-y-set! win-located (* y-factor (window-height win-located)))
	  (ani s-located)))))

  (define duration
    (lambda (ani t)
      (let ([started #f])
	(lambda (s)
	  (unless started
	    (set! started (state-time s)))
	  (when (< (- (state-time s) started) t)
	    (ani s))
	  ))))

  (define trigger
    (lambda (ani t)
      (let ([started #f])
	(lambda (s)
	  (unless started
	    (set! started (state-time s)))
	  (unless (< (- (state-time s) started) t)
	    (ani s))))))

  (define chain
    (lambda args ;; 接受变长参数
      (let loop ([rest args]          ;; 剩余的参数
		 [current-time 0.0]   ;; 当前累计的时间游标
		 [anis '()])          ;; 收集到的动画列表
	(if (null? rest)
            ;; 递归结束，将收集到的所有 trigger 包装进 parallel
            ;; 注意：accumulated list 需要 reverse
            (apply parallel (reverse anis))
            
            (let ([head (car rest)])
              (cond
               ;; 情况1：遇到数字 -> 增加时间游标（Delay）
               [(number? head)
		(loop (cdr rest) 
                      (+ current-time head) 
                      anis)]
               
               ;; 情况2：遇到动作 -> 用 trigger 锁定在当前时间点
               [else
		(loop (cdr rest) 
                      current-time 
                      (cons (trigger head current-time) anis))]))))))

  )

