(library (loader)
  (export *text* phone dialogue effect transition sound resource-collect resource-guardian texture phone camera color make-Color music *musics* inspector *current-viewport* *previous-viewport* *viewport-dest* *viewport-src* *viewport-origin* *current-rt* *previous-rt* *viewport-camera* viewport-init *viewport-scale* *viewport-buffer*)
  (import (chezscheme)
	  (state)
	  (tool)
	  (raylib ffi)
	  (raylib constant))

  (define *viewport-scale* (make-parameter 1.0))

  (define *max-concurrent-loads* 3)
  
  (define *active-loads* 0)
  (define *load-mutex* (make-mutex))
  (define *load-condition* (make-condition))

  (define *current-viewport* (make-parameter #f))
  (define *previous-viewport* (make-parameter #f))
  (define *transition-snapshot* (make-parameter #f))
  (define *viewport-buffer* (make-parameter #f))
  (define *current-rt* (make-parameter #f))
  (define *previous-rt* (make-parameter #f))
  (define *viewport-dest* (make-parameter #f))
  (define *viewport-src* (make-parameter #f))
  (define *viewport-origin* (make-parameter #f))
  (define *viewport-camera* (make-parameter #f))

  (define viewport-init
    (lambda ()
      (let* ([scale (GetWindowScaleDPI)]
	     [scale-x (Vector2-x scale)]
	     [scale-y (Vector2-y scale)])
	(*viewport-scale* (max scale-x scale-y))
	(let ([phys-w (flonum->fixnum (* 1920 scale-x))]
	      [phys-h (flonum->fixnum (* 1080 scale-y))])
	  (*viewport-src* (make-Rectangle 0.0 0.0 (inexact phys-w) (- (inexact phys-h))))
	  (*current-rt* (LoadRenderTexture phys-w phys-h))
	  (*previous-rt* (LoadRenderTexture phys-w phys-h))
	  (*viewport-buffer* (LoadRenderTexture phys-w phys-h))
	  (*transition-snapshot* (LoadRenderTexture phys-w phys-h))))
      (SetTextureFilter (RenderTexture-texture (*current-rt*)) 1)
      (SetTextureFilter (RenderTexture-texture (*viewport-buffer*)) 1)
      (SetTextureFilter (RenderTexture-texture (*previous-rt*)) 1)
      (SetTextureFilter (RenderTexture-texture (*transition-snapshot*)) 1)
      (resource-guardian (*current-rt*))
      (resource-guardian (*viewport-buffer*))
      (resource-guardian (*previous-rt*))
      (resource-guardian (*transition-snapshot*))

      (*viewport-camera* (make-Camera2D '(0.0 . 0.0) '(0.0 . 0.0) 0.0 (*viewport-scale*)))
      (resource-guardian (*viewport-camera*))
      
      (*viewport-dest* (make-Rectangle 0.0 0.0 0.0 0.0))

      (*viewport-origin* (make-Vector2 0.0 0.0))

      (resource-guardian (*viewport-src*))
      (resource-guardian (*viewport-dest*))
      (resource-guardian (*viewport-origin*))))

  (define acquire-load-slot
    (lambda ()
      (with-mutex *load-mutex*
        (let loop ()
          (if (>= *active-loads* *max-concurrent-loads*)
              (begin
                ;; 如果名额已满，线程在此沉睡等待，不消耗 CPU 和 内存
                (condition-wait *load-condition* *load-mutex*)
                (loop))
              ;; 获得名额
	      (set! *active-loads* (+ *active-loads* 1)))))))

  (define release-load-slot
    (lambda ()
      (with-mutex *load-mutex*
        (set! *active-loads* (- *active-loads* 1))
        ;; 唤醒下一个等待的线程
        (condition-signal *load-condition*))))
  
  (define resource-guardian (make-guardian))
  
  (define resource-free
    (lambda (res)
      (cond
       [(ftype-pointer? res)
	(case (ftype-pointer->ftype-symbol res)
	  [(Music)
	   (UnloadMusicStream res)
	   (TraceLog LOG_INFO (format-green "Unload Music Resurce ~a" res))]
	  [(Font)
	   (UnloadFont res)
	   (TraceLog LOG_INFO (format-green "Unload Font Resurce ~a" res))]
	  [(Image)
	   (when (IsImageValid res)
             (UnloadImage res))
           (TraceLog LOG_INFO (format-green "Unload Image Resurce ~a" res))]
	  [(Texture Texture2D)
	   (UnloadTexture res)
	   (TraceLog LOG_INFO (format-green "Unload Texture Resurce ~a" res))]
	  [(Shader)
	   (UnloadShader res)
	   (TraceLog LOG_INFO (format-green "Unload Shader Resurce ~a" res))]
	  [(RenderTexture RenderTexture2D)
	   (UnloadRenderTexture res)
	   (TraceLog LOG_INFO (format-green "Unload RenderTexture Resurce ~a" res))]
	  [(Sound)
	   (UnloadSound res)
	   (TraceLog LOG_INFO (format-green "Unload Sound Resurce ~a" res))]
	  [(Vector2 Vector Rectangle)
	   (foreign-free (ftype-pointer-address res))
	   (TraceLog LOG_INFO (format-green "Unload Vector/Rectangle Resurce ~a" res))]
	  [(Camera Camera2D)
	   (foreign-free (ftype-pointer-address res))
	   (TraceLog LOG_INFO (format-green "Unload Camera2D Resurce ~a" res))
	   ]
	  [(Color)
	   (foreign-free (ftype-pointer-address res))
	   (TraceLog LOG_INFO (format-green "Unload Color Resurce ~a" res))]
	  )]
       [else
	(foreign-free res)
	(TraceLog LOG_INFO (format-green "Unload Normal Resurce ~a" res))])))
  
  (define resource-collect
    (lambda ()
      (let loop ()
	(let ([res (resource-guardian)])
	  (when res
	    (resource-free res)
	    (loop))))))

  (define load-texture-async
    (lambda (path)
      (let ([future (make-resource (make-mutex) 'loading #f)])
	(fork-thread
	 (lambda ()
	   (guard (x [else 
                      (display (format "Error in loader thread for ~a: ~a\n" path x))
                      (TraceLog LOG_ERROR (format "Scheme Error: ~a" x))
		      (with-mutex (resource-lock future)
			(resource-status-set! future 'error))
		      (release-load-slot)])
	     (acquire-load-slot)
	     (let ([img (LoadImage path)])
					;	     (resource-guardian img)
	       (with-mutex (resource-lock future)
		 (resource-data-set! future img)
		 (resource-status-set! future 'ram-ready))
	       (TraceLog LOG_INFO (format-green "Async: RAM loaded for ~a\n" path))
	       (release-load-slot)))))
	future)))

  (define-syntax texture
    (syntax-rules ()
      [(_ name path)
       (define name (load-texture-async path))]))

  (define-syntax sound
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let ([so (LoadSound path)])
	   (resource-guardian so)
	   so))]))

  (define *musics* (make-parameter '()))
  
  (define-syntax music
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let ([mus (LoadMusicStream path)])
	   (ftype-set! Music (looping) mus #t)
	   (resource-guardian mus)
	   mus))]))
  
  (define-syntax transition
    (syntax-rules ()
      [(_ name vs fs)
       (define name
	 (let* ([sh (LoadShader vs fs)] 
		[texture1-location (GetShaderLocation sh "texture1")]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)]
		)
	   (resource-guardian sh)
	   (resource-guardian progress-fptr)
	   (lambda (ani duration)
	     (let ([started #f] [progress 0.0] [prev #f])
	       (lambda (s)
		 (unless prev
		   (BeginTextureMode (*transition-snapshot*))
		   (ClearBackground BLANK)
		   (DrawTextureRec (RenderTexture-texture (*previous-viewport*)) (*viewport-src*) (*viewport-origin*) WHITE)
		   (EndTextureMode)
		   (BeginTextureMode (*current-viewport*))
		   (set! prev (RenderTexture-texture (*transition-snapshot*))))
		 (unless started
		   (set! started (state-time s)))

		 (BeginTextureMode (*viewport-buffer*))
		 (ClearBackground BLANK)
		 (BeginMode2D (*viewport-camera*))
		 (ani s)
		 (EndMode2D)
		 (EndTextureMode)
		 (BeginTextureMode (*current-viewport*))

		 (BeginShaderMode sh)
		 (when (< progress 1.0)
		   (set! progress (/ (- (state-time s) started) duration))
		   (SetShaderValueTexture sh texture1-location prev)
		   (ftype-set! float () progress-fptr progress)
		   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))
		   (DrawTextureRec (RenderTexture-texture (*viewport-buffer*)) (*viewport-src*) (*viewport-origin*) WHITE)
		   (EndShaderMode))
	       ))))]))

  (define-syntax effect
    (syntax-rules ()
      [(_ name vs fs)
       (define name
	 (let* ([sh (LoadShader vs fs)]
		[progress-location (GetShaderLocation sh "progress")]
		[progress-ptr (foreign-alloc (ftype-sizeof float))]
		[progress-fptr (make-ftype-pointer float progress-ptr)])
	   (resource-guardian sh)
	   (resource-guardian progress-fptr)
	   (lambda (ani duration)
	     (let ([started #f] [progress 0.0])
	       (lambda (s)
		 (unless started
		   (set! started (state-time s)))

		 (BeginTextureMode (*viewport-buffer*))
		 (ClearBackground BLANK)
		 (ani s)
		 (EndTextureMode)
		 (BeginTextureMode (*current-viewport*))
		 
		 (BeginShaderMode sh)
		 (when (< progress 1.0)
		   (if (eqv? #t duration)
		       (set! progress 1.0)
		       (set! progress (/ (- (state-time s) started) duration)))
		   (ftype-set! float () progress-fptr progress)
		   (SetShaderValue sh progress-location progress-ptr SHADER_UNIFORM_FLOAT))
		 (DrawTextureRec (RenderTexture-texture (*viewport-buffer*)) (*viewport-src*) (*viewport-origin*) WHITE)
		 (EndShaderMode))
	       ))))]))

  (define *text* (make-parameter #f))

  (define *color* (make-parameter WHITE))
  (define color
    (lambda (r g b a ani)
      (let ([color #f])
	(lambda (s)
	  (unless color
	    (set! color (make-Color r g b a))
	    (resource-guardian color))
	  (parameterize ([*color* color])
	    (ani s))))))
  
  (define-syntax dialogue
    (syntax-rules ()
      [(_ name path)
       (define name
	 (let* ([codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int)))]
		[codepoints (LoadCodepoints (*text*) codepoints-count)]
		[font (LoadFontEx path 50 codepoints (ftype-ref int () codepoints-count))])
	   (resource-guardian font)
	   (UnloadCodepoints codepoints)
	   (foreign-free (ftype-pointer-address codepoints-count))
	   (lambda (text)
	     (let* ([position (make-Vector2 0.0 0.0)]
		    [measured-vec (MeasureTextEx font text 50.0 0.0)]
		    [measured-x (Vector2-x measured-vec)]
		    [measured-y (Vector2-y measured-vec)]
		    [origin-x (/ measured-x 2.0)]
		    [origin-y (/ measured-y 2.0)]
		    [origin (make-Vector2 origin-x origin-y)]
		    [started #f] [color #f] [bg-box (make-Rectangle 0.0 0.0 0.0 0.0)]
		    [bg-color (make-Color 0 0 0 100)])
	       (resource-guardian position)
	       (resource-guardian origin)
	       (resource-guardian bg-box)
	       (resource-guardian bg-color)
	       (lambda (s)
		 (unless started (set! started (state-time s)))
		 (unless color (set! color (*color*)))
		 (let* ([win (state-window s)]
			[win-width (window-width win)]
			[win-height (window-height win)]
			[center-x (* win-width 0.5)]
			[center-y (* win-height 0.9)]
			[start-x (- center-x origin-x)]
			[start-y (- center-y origin-y)]
			[passed (- (state-time s) started)])
		   (when (< passed 3.0)
		     (Vector2-x-set! position center-x)
		     (Vector2-y-set! position center-y)
		     (Rectangle-x-set! bg-box (- start-x 10))
		     (Rectangle-y-set! bg-box (- start-y 10))
		     (Rectangle-width-set! bg-box (+ measured-x 20))
		     (Rectangle-height-set! bg-box (+ measured-y 20))
		     (DrawRectangleRounded bg-box 0.5 10 bg-color)
		     (DrawTextPro font text position origin 0.0 50.0 0.0 color)))
		 )))))]))

  (define-syntax phone
    (syntax-rules ()
      [(_ name phone-w phone-h)
       (define name
	 (let* ([w (GetScreenWidth)]
		[h (GetScreenHeight)]
		[round-rec (make-Rectangle (- (/ w 2.0) (/ phone-w 2.0)) (- (/ h 2.0) (/ phone-h 2.0)) (inexact phone-w) (inexact phone-h))]
		[src #f])
	   (resource-guardian round-rec)
	   (lambda (res)
	     (let ([origin (make-Vector2 0.0 0.0)])
	       (resource-guardian origin)
	       (lambda (s)
		 (let ([current-status #f] [current-data #f])
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
		      (TraceLog LOG_INFO "Async: Uploading Image to VRAM ...")
		      (let ([tex (LoadTextureFromImage current-data)])
			(resource-guardian tex)
			(with-mutex (resource-lock res)
			  (resource-data-set! res tex)
			  (resource-status-set! res 'gpu-ready)
			  (UnloadImage current-data)
			  (TraceLog LOG_INFO "Optimization: Phone Image freed manually.")
			  ))]
		     [(gpu-ready)
		      (unless src
			(set! src (make-Rectangle 0.0 0.0 (inexact (Texture-width current-data)) (inexact (Texture-height current-data))))
			(resource-guardian src))
		      (DrawRectangleRounded round-rec 0.25 8 BLACK)
		      (DrawTexturePro current-data src round-rec origin 0.0 WHITE)
		      (DrawRectangleRoundedLinesEx round-rec 0.25 8 6.0 LIGHTGRAY)
		      ])))))))]))

  (define-syntax inspector
    (syntax-rules ()
      [(_ name)
       (define name
         (let ([start-x 0] 
               [start-y 0] 
               [is-dragging #f])
           (lambda (ani)
             (lambda (s)
               ;; 1. 先绘制原本的游戏画面
               (ani s)

               ;; 2. 获取鼠标数据 (使用 Raylib 基础函数)
               (let ([mx (GetMouseX)]
                     [my (GetMouseY)])

                 ;; --- 逻辑：鼠标状态机 ---
                 ;; A. 按下瞬间：记录起点
                 (when (IsMouseButtonPressed 0) ;; 0 = MOUSE_BUTTON_LEFT
                   (set! start-x mx)
                   (set! start-y my)
                   (set! is-dragging #t))

                 ;; B. 松开瞬间：停止拖拽
                 (when (IsMouseButtonReleased 0)
                   (set! is-dragging #f))

                 ;; --- 绘制：实时坐标 (绿色) ---
                 ;; 在鼠标旁边显示 X,Y，方便随时看点
                 (DrawText (format "POS: ~a, ~a" mx my) (+ mx 15) my 20 GREEN)

                 ;; --- 绘制：拖拽产生的矩形 (红色) ---
                 (when (and is-dragging (IsMouseButtonDown 0))
                   (let* ([rx (min start-x mx)]           ;; 左上角 X
                          [ry (min start-y my)]           ;; 左上角 Y
                          [rw (abs (- mx start-x))]       ;; 宽度
                          [rh (abs (- my start-y))])      ;; 高度
                     
                     ;; 画红框
                     (DrawRectangleLines rx ry rw rh RED)
                     ;; 在框下面显示详细数据，可以直接抄写到代码里
                     ;; 格式: X Y W H
                     (DrawText (format "RECT: ~a ~a ~a ~a" rx ry rw rh) rx (+ ry rh 10) 20 RED)
                     ))
                 )))))]))

  (define-syntax camera
    (syntax-rules ()
      [(_ name movment)
       (define name
	 (lambda (ani)
	   (let* ([started #f]
		  [ca (init-Camera2D)])
	     (resource-guardian ca)
	     (lambda (s)
	       (unless started
		 (set! started (state-time s)))
	       (let ([ratio (*viewport-scale*)])
		 (call-with-values
		     (lambda () (movment (- (state-time s) started)))
		   (lambda (off-x off-y tar-x tar-y ro zo)
		     (ftype-set! Camera2D (offset x) ca (* ratio off-x))
                     (ftype-set! Camera2D (offset y) ca (* ratio off-y))
                     (ftype-set! Camera2D (target x) ca tar-x)
                     (ftype-set! Camera2D (target y) ca tar-y)
                     (Camera2D-rotation-set! ca ro)
                     (Camera2D-zoom-set! ca (* ratio zo))))
		 (BeginMode2D ca)
		 (ani s)
		 (EndMode2D)
		 )))))]))
  )
