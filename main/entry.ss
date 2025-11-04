(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

					; --- resource type cache ---
(define *cache* (make-hashtable equal-hash equal?))
(define resource-cache
  (lambda (keys loader)
    (if (hashtable-contains? *cache* keys)
	(hashtable-ref *cache* keys (lambda () (error 'resource-cache "No resource cached" keys)))
	(let ([res (loader)])
	  (hashtable-set! *cache* keys res)
	  res))))

(define-record-type region
  (fields x y width height))

(define region->Rectangle
  (lambda (reg)
    (let ([x (region-x reg)] [y (region-y reg)]
	  [w (region-width reg)] [h (region-height reg)])
      (make-Rectangle (exact->inexact x)
		      (exact->inexact y)
		      (exact->inexact w)
		      (exact->inexact h)))))

(define fragment<-music
  (lambda (music)
    (PlayMusicStream music)
    (lambda (dest-reg)
      (lambda () (UpdateMusicStream music)))))

(define fragment<-texture
  (lambda (texture)
    (let ([tex-w (* 1.0 (Texture-width texture))]
	  [tex-h (* 1.0 (Texture-height texture))])
      (let ([src-rect-default (make-Rectangle 0.0 0.0 tex-w tex-h)]
	    [prev-dest #f] [prev-src #f] [prev-ren-default #f]
	    [prev-ren-cropped #f])
	(let ([dest-rect-calculator (lambda (dest-reg)
				      (let* ([dest-w (region-width dest-reg)] [dest-h (region-height dest-reg)]
					     [dest-x (region-x dest-reg)] [dest-y (region-y dest-reg)]
					     [scale (max (/ dest-w tex-w) (/ dest-h tex-h))]
					     [scaled-w (* tex-w scale)] [scaled-h (* tex-h scale)]
					     
					     [dest-rect (make-Rectangle (+ dest-x (/ dest-w 2.0)) (+ dest-y (/ dest-h 2.0)) scaled-w scaled-h)]
					     )
					dest-rect))])
	  (case-lambda
	  [(dest-reg)
	   (if (equal? dest-reg prev-dest) prev-ren-default
	       (let* ([dest-rect (dest-rect-calculator dest-reg)]
		      [center (make-Vector2 (/ (region-width dest-rect) 2.0) (/ (region-height dest-rect) 2.0))])
	      	(set! prev-dest dest-reg)
		(set! prev-ren-default
		      (lambda ()
			(DrawTexturePro texture src-rect-default dest-rect center 0.0 WHITE)))
		prev-ren-default))]))))))

(define overlay
  (lambda frags
    (lambda (reg)
      (let ([rens (map (lambda (frag) (frag reg)) frags)])
	(lambda ()
	  (for-each (lambda (ren) (ren)) rens))))))

(define move
  (lambda (frag offset)
    (lambda (reg)
      (let ([x-offset (car offset)] [y-offset (cdr offset)]
	    [x (region-x reg)] [y (region-y reg)]
	    [w (region-width reg)] [h (region-height reg)])
	(let ([rect-moved (make-region (+ x x-offset) (+ y y-offset) w h)])
	  (lambda ()
	    ((frag rect-moved))))))))

(define locate-dialogue
  (lambda (frag)
    (lambda (reg)
      (let* ([x (region-x reg)] [y (region-y reg)] [w (region-width reg)] [h (region-height reg)]
	     [dialogue-x (* w 0.2)] [dialogue-y (* h 0.75)] [dialogue-w (* w 0.6)] [dialogue-h (* h 0.2)]
	     [dialogue-reg (make-region dialogue-x dialogue-y dialogue-w dialogue-h)])
	(lambda ()
	  ((frag dialogue-reg)))))))

; --- --- --- 

(define make-animation
  (lambda (animator end?)
    (lambda (reg)
      (let animating ([passed 0.0])
	(BeginDrawing)
	(ClearBackground BLACK)
	(((animator passed) reg))
	(EndDrawing)
	(unless (or (end? passed) (WindowShouldClose))
	  (animating (+ passed (GetFrameTime))))))))

(define animator<-shader
  (lambda (vs fs time)
    (let* ([shader (LoadShader vs fs)]
	   [ptr (foreign-alloc (ftype-sizeof float))]
	   [fptr (make-ftype-pointer float ptr)]
	   [loc (GetShaderLocation shader "progress")])
    (lambda (frag)
      (lambda (passed)
	(ftype-set! float () fptr (min (/ passed time) 1.0))
	(SetShaderValue shader loc ptr SHADER_UNIFORM_FLOAT)
	(lambda (reg)
	  (lambda ()
	    (BeginShaderMode shader)
	    ((frag reg))
	    (EndShaderMode))))))))
      
(define static
  (lambda (frag)
    (lambda (progress)
      frag)))

(define parallel
  (lambda anis
    (lambda (passed)
      (apply overlay
	     (map (lambda (ani) (ani passed)) anis)))))

(define sounder
  (case-lambda
    [(sound) (sounder sound #f)]
    [(sound time)
       (let ([played #f])
	 (lambda (passed)
	   (lambda (reg)
	     (lambda ()
	       (unless played
		 (set! played #t)
		 (PlaySound sound))
	       (when (and time (>= passed time))
		 (StopSound sound))))))]))

(define dialoguer
  (lambda (text)
    (let ([writer (typewriter text 50 0.1)])
      (lambda (passed)
	(locate-dialogue (writer passed))))))

(define typewriter
  (lambda (text fz speed)
    (let* ([text-len (string-length text)]
	   [codepoints (LoadCodepoints text codepoints-count)]
	   [font (LoadFontFromMemory ".ttf" font-data (ftype-ref int () font-size) fz codepoints (ftype-ref int () codepoints-count))]
	   [fz-float (exact->inexact fz)])
      (lambda (passed)
	(let* ([subtext-index (min text-len (inexact->exact (floor (/ passed speed))))]
	       [subtext (substring text 0 subtext-index)]
	       [measured-vec (MeasureTextEx font subtext fz-float 0.0)]
	       [text-w (Vector2-x measured-vec)] [text-h (Vector2-y measured-vec)])
	(lambda (reg)
	  (let* ([x (region-x reg)] [y (region-y reg)] [w (region-width reg)] [h (region-height reg)]
		 [text-x (+ x (/ (- w text-w) 2.0))]
		 [text-y (exact->inexact y)]
		 [vec-for-tex (make-Vector2 text-x text-y)])
	    (lambda ()
	      (DrawRectangle (inexact->exact (floor text-x)) (inexact->exact (floor text-y))
			     (inexact->exact (floor text-w)) (inexact->exact (floor text-h))
	       (make-Color 120 120 160 125))
	      (DrawTextEx font subtext vec-for-tex fz-float 0.0 WHITE)))))))))
 
(define partition-by-index
  (lambda (li)
    (let ([len (length li)])
      (let collect ([even '()] [old '()] [index 0] [rest li])
	(cond
	 [(null? rest) (values (reverse even) (reverse old))]
	 [(even? index) (collect (cons (car rest)  even)
				 old (1+ index) (cdr rest))]
	 [(odd? index) (collect even (cons (car rest) old)
				(1+ index) (cdr rest))])))))

(define sequential
  (lambda timelines
    (let-values ([(times animators) (partition-by-index timelines)])
      (let ([len (length animators)])
	(lambda (passed)
	  (let-values ([(actived-times left-times) (partition (lambda (t) (>= passed t)) times)])
	    (let* ([applyed-total-times (append (cdr actived-times) (list passed))]
		   [applyed-diff-times (map (lambda (start end) (- end start)) actived-times applyed-total-times)]
		   [applyed-animators (list-head animators (length actived-times))])
	      (apply
	       overlay
	       (map
		(lambda (animator time)
		  (animator time))
		applyed-animators
		applyed-diff-times)))))))))

(define main
  (lambda ()
    (InitWindow (GetScreenWidth) (GetScreenHeight) "TEST")
    (InitAudioDevice)
    (SetTargetFPS 60)
    (test-init)
    (let* ([whole-region (make-region 0.0 0.0 (* (GetScreenWidth) 1.0)
				      (* (GetScreenHeight) 1.0))]
	   [anis (list (animation-1) (animation-2) (animation-3))])
      (for-each (lambda (ani) (ani whole-region)) anis)
      (CloseAudioDevice)
      (CloseWindow))))

(define (animation-1)
  (make-animation
   (parallel
    (sounder ring)
    (static bg-black))
   (lambda (passed) (IsMouseButtonPressed MOUSE_BUTTON_LEFT))))

(define (animation-2)
  (let ([wakeup (animator<-shader #f "../assets/glsl/wakeup.transition.fs" 2.0)])
    (make-animation
     (sequential
      0.0 (wakeup bg-morning-fra)
      2.0 (sounder searching 2.5)
      5.0 (sounder thud #f)
      5.5 (dialoguer "好痛……！"))
     (lambda (passed) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))))

(define (animation-3)
  (let ([mask (animator<-shader #f "../assets/glsl/mask.effect.fs" 1.0)]
	[fade (animator<-shader #f "../assets/glsl/fade.transition.fs" 1.0)]
	[ca (init-Camera2D)])
    (Camera2D-zoom-set! ca 2.0)
    (make-animation
      (parallel (sounder pickup)
		(lambda (passed)
		  ((mask (move bg-morning-fra `(,(* 10 passed) . 0.0))) passed)))
     (lambda (passed) (IsMouseButtonPressed MOUSE_BUTTON_LEFT)))))

(define test-init
  (lambda ()
    (set! bg-morning-fra (fragment<-texture (LoadTexture "../assets/bg/yuwen.bedroom.morning.png")))
    (set! char-pic (fragment<-texture (LoadTexture "../assets/character/0896.png")))
    (set! font-size (make-ftype-pointer Font (foreign-alloc (ftype-sizeof Font))))
    (set! font-data (LoadFileData "../assets/font/Xiaolai-Regular.ttf" font-size))
    (set! codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int))))
    (set! bgm-fra (fragment<-music (LoadMusicStream "../assets/bgm/midnight-trip.mp3")))
    (set! bg-black (fragment<-texture (LoadTexture "../assets/bg/black.png")))
    (set! ring (LoadSound "../assets/sound/rightone.mp3"))
    (set! pickup (LoadSound "../assets/sound/pickup-phone.mp3"))
    (set! searching (LoadSound "../assets/sound/searching.mp3"))
    (set! thud (LoadSound "../assets/sound/thud.mp3"))))
