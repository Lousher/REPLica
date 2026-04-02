(library (rpl render)
  (export init uninit draw)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant)
	  (rpl scene)
	  (vm main))

  (define *sdf-shader* #f)
  (define *label-dest* #f)
  (define *label-origin* #f)
  (define init
    (lambda ()
;      (SetConfigFlags FLAG_VSYNC_HINT)
      (InitWindow 1920 1080 "REPLica Engine")
      (InitAudioDevice)
      (set! *sdf-shader* (LoadShader #f "main/sdf.fs"))
      (set! *label-dest* (make-rectangle 0.0 0.0 0.0 0.0))
      (set! *label-origin* (make-vector2 0.0 0.0))
      ;(SetTargetFPS 60) 影响异步资源加载速度
      ))

  (define uninit
    (lambda ()
      (CloseAudioDevice)
      (CloseWindow)))

  (define (reset-audio-status node)
    (when (eq? (scene-node-type node) 'audio)
      (scene-node-data-set! node 'ready))
    (for-each reset-audio-status (scene-node-children node)))

  (define draw
    (lambda (vm node mx my vs ox oy)
      (when (scene-node-visible? node)
	(let* ([log-x (scene-node-x node)]
	       [log-y (scene-node-y node)]
	       [log-s (scene-node-scale-x node)]
	       [rot (scene-node-rotation node)]
	       [alpha (scene-node-alpha node)]
	       [color (scene-node-color node)]
	       [phys-x (+ (* log-x vs) ox)]
	       [phys-y (+ (* log-y vs) oy)]
	       [phys-s (* log-s vs)])
	  (Color-a-set! color (inexact->exact (round (* 255 alpha))))
	  (case (scene-node-type node)
	    [(texture)
	     (let ([payload (scene-node-payload node)])
               ;; 【修复 1】资源就绪时，直接在同一帧更新 payload，消除 1 帧落差引起的闪烁
	       (when (symbol? payload)
		 (let* ([assets (state-assets vm)] [mtx (state-asset-mutex vm)]
			[entry (with-mutex mtx (hashtable-ref assets payload #f))])
		   (when entry
		     (case (vector-ref entry 2)
		       [(image-ready)
			(let* ([img (vector-ref entry 3)] [tex (LoadTextureFromImage img)])
			  (SetTextureFilter tex 1) (UnloadImage img)
			  (with-mutex mtx (vector-set! entry 2 'texture-ready) (vector-set! entry 3 tex))
                          (scene-node-payload-set! node tex)
                          (set! payload tex))] ;; 本地同步更新
		       [(texture-ready)
                        (let ([tex (vector-ref entry 3)])
			  (scene-node-payload-set! node tex)
                          (set! payload tex))]))))
               ;; 如果此时 payload 已是可用纹理，立即绘制！
               (unless (symbol? payload)
                 (let* ([tex payload] [tw (Texture-width tex)] [th (Texture-height tex)]
			[src (scene-node-src node)] [dest (scene-node-dest node)] [origin (scene-node-origin node)])
                   (when (zero? (Rectangle-width src))
                     (Rectangle-width-set! src (inexact tw)) (Rectangle-height-set! src (inexact th)))
                   (Rectangle-x-set! dest (inexact phys-x)) (Rectangle-y-set! dest (inexact phys-y))
                   (Rectangle-width-set! dest (* tw phys-s)) (Rectangle-height-set! dest (* th phys-s))
                   (DrawTexturePro tex src dest origin (inexact rot) color))))]
	    [(label)
	     (let ([payload (scene-node-payload node)])
	       (when (symbol? payload)
		 (let* ([assets (state-assets vm)] [mtx (state-asset-mutex vm)]
			[entry (with-mutex mtx (hashtable-ref assets payload #f))])
		   (when entry
		     (case (vector-ref entry 2)
		       [(typeface-image-ready)
			(let* ([payload-data (vector-ref entry 3)]
			       [img (car payload-data)] [glyph-map (cdr payload-data)] [tex (LoadTextureFromImage img)])
			  (SetTextureFilter tex 1) (UnloadImage img)
			  (with-mutex mtx (vector-set! entry 2 'typeface-ready) (vector-set! entry 3 (cons tex glyph-map)))
                          (let ([new-payload (cons tex glyph-map)])
                            (scene-node-payload-set! node new-payload)
                            (set! payload new-payload)))]
		       [(typeface-ready) 
                        (let ([new-payload (vector-ref entry 3)])
                          (scene-node-payload-set! node new-payload)
                          (set! payload new-payload))]))))
               (unless (symbol? payload)
                 (let* ([atlas-tex (car payload)] [glyph-map (cdr payload)]
			[str (scene-node-data node)] [s (* (/ 24.0 128.0) log-s)])
		   (BeginShaderMode *sdf-shader*)
		   (let loop ([chars (string->list str)] [cx 0.0])
		     (unless (null? chars)
		       (let* ([cp (char->integer (car chars))] [info (hashtable-ref glyph-map cp #f)])
			 (if info
			   (let ([src (vector-ref info 0)] [g-ox (vector-ref info 1)] [g-oy (vector-ref info 2)] [adv (vector-ref info 3)])
			     (Rectangle-x-set! *label-dest* (inexact (+ phys-x (* (+ cx g-ox) s vs))))
			     (Rectangle-y-set! *label-dest* (inexact (+ phys-y (* g-oy s vs))))
			     (Rectangle-width-set! *label-dest* (inexact (* (Rectangle-width src) s vs)))
			     (Rectangle-height-set! *label-dest* (inexact (* (Rectangle-height src) s vs)))
			     (DrawTexturePro atlas-tex src *label-dest* *label-origin* (inexact rot) color)
			     (loop (cdr chars) (+ cx adv)))
			   (loop (cdr chars) (+ cx 30.0))))))
		   (EndShaderMode))))]
	    [(audio)
             (let ([payload (scene-node-payload node)])
               (when (symbol? payload)
                 (let* ([assets (state-assets vm)] [mtx (state-asset-mutex vm)]
                        [entry (with-mutex mtx (hashtable-ref assets payload #f))])
                   (when entry
                       (case (vector-ref entry 2)
                         [(wav-ready)
                          (let* ([wav (vector-ref entry 3)] [snd (LoadSoundFromWave wav)])
                            (UnloadWave wav)
                            (with-mutex mtx (vector-set! entry 2 'sound-ready) (vector-set! entry 3 snd))
                            (scene-node-payload-set! node snd)
                            (set! payload snd))]
                         [(sound-ready)
			  (let ([snd (vector-ref entry 3)])
                            (scene-node-payload-set! node snd)
                            (set! payload snd))]))))
               (unless (symbol? payload)
                 (let ([status (scene-node-data node)])
                   (when (eq? status 'ready)
                     (PlaySound payload)
                     (scene-node-data-set! node 'played)))))]
	    [(interact)
             (let* ([node-data (scene-node-data node)] [scope (car node-data)] [cases (cadr node-data)]
                    [w (* (car scope) log-s)] [h (* (cadr scope) log-s)]
                    [is-hover? (and (>= mx log-x) (<= mx (+ log-x w)) (>= my log-y) (<= my (+ log-y h)))]
                    [is-click? (and (IsMouseButtonPressed MOUSE_BUTTON_LEFT) is-hover?)])
               (for-each
                (lambda (ca)
                  (let* ([ctype (car ca)] [sub-node (cdr ca)]
                         ;; 【修复 2】极其精简的状态逻辑：else 只代表“未悬浮”
                         [matched? (case ctype [2 is-click?] [1 is-hover?] [0 (not is-hover?)])])
                    (if matched?
                        (draw vm sub-node mx my vs ox oy)
                        ;; 【修复 3】如果条件不再匹配（例如松开鼠标），重置子节点的声音状态
                        (reset-audio-status sub-node))))
                cases))])
	  (unless (eq? (scene-node-type node) 'interact)
	    (for-each
	     (lambda (child)
	       (draw vm child mx my vs ox oy))
	     (scene-node-children node)))))))
  )
