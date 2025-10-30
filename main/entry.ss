(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

					; primitive: regin renderer
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

(define make-fragment-from-texture
  (lambda (texture)
    (let ([tex-w (* 1.0 (Texture-width texture))]
	  [tex-h (* 1.0 (Texture-height texture))])
      (lambda (dest-reg)
	(let* ([dest-w (region-width dest-reg)] [dest-h (region-height dest-reg)]
	       [dest-x (region-x dest-reg)] [dest-y (region-y dest-reg)]
	       [scale (max (/ dest-w tex-w) (/ dest-h tex-h))]
	       [scaled-w (* tex-w scale)] [scaled-h (* tex-h scale)]
	       [src-rect (make-Rectangle 0.0 0.0 tex-w tex-h)]
	       [dest-rect (make-Rectangle (+ dest-x (/ dest-w 2.0)) (+ dest-y (/ dest-h 2.0)) scaled-w scaled-h)]
	       [center (make-Vector2 (/ scaled-w 2.0) (/ scaled-h 2.0))])
	  (lambda ()
	    (DrawTexturePro texture src-rect dest-rect center 0.0 WHITE)))))))

(define make-fragments-from-text
  (lambda (text fz)
    (let* ([codepoints (LoadCodepoints text codepoints-count)]
	   [font (LoadFontFromMemory ".ttf" font-data (ftype-ref int () font-size) fz codepoints (ftype-ref int () codepoints-count))]
	   [fz-float (exact->inexact fz)])
      (UnloadCodepoints codepoints)
      (let* ([len (string-length text)]
	     [subtext-indexs (iota (1+ len))])
	(map
	 (lambda (subtext-index)
	   (let* ([subtext (substring text 0 subtext-index)]
		  [measured-vec (MeasureTextEx font subtext fz-float 0.0)])
	     (lambda (reg)
	       (let* ([x (region-x reg)] [y (region-y reg)] [w (region-width reg)] [h (region-height reg)]
		      [text-x (+ x (/ (- w (Vector2-x measured-vec)) 2.0))]
		      [vec-for-tex (make-Vector2 text-x (exact->inexact y))])
		 (lambda ()
		   (DrawTextEx font subtext vec-for-tex fz-float 0.0 WHITE))))))
	 subtext-indexs)))))


(define flat-vertical
  (lambda frags
    (let ([count (length pics)])
      (lambda (reg)
	(let ([w-seg (* (/ (region-width reg) count) 1.0)])
	  (lambda ()
	    (for-each
	     (lambda (frag index)
	       (let ([x (* index w-seg)] [y 0] [w w-seg] [h (region-height reg)])
		 (let ([rect-index (make-region x y w h)])
		   ((frag rect-index)))))
	     frags
	     (iota count))))))))

(define overlay-fragment
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

(define dialogue-locate
  (lambda (frag)
    (lambda (reg)
      (let* ([x (region-x reg)] [y (region-y reg)] [w (region-width reg)] [h (region-height reg)]
	     [dialogue-x (* w 0.2)] [dialogue-y (* h 0.7)] [dialogue-w (* w 0.6)] [dialogue-h (* h 0.2)]
	     [dialogue-reg (make-region dialogue-x dialogue-y dialogue-w dialogue-h)])
	(lambda ()
	  ((frag dialogue-reg)))))))

(define test-init
  (lambda ()
    (set! texture1 (LoadTexture "../assets/bg/yuwen.bedroom.morning.png"))
    (set! texture2 (LoadTexture "../assets/character/0896.png"))
    (set! bg-pic (make-fragment-from-texture texture1))
    (set! char-pic (make-fragment-from-texture texture2))
    (set! font-size (make-ftype-pointer Font (foreign-alloc (ftype-sizeof Font))))
    (set! font-data (LoadFileData "../assets/font/Xiaolai-Regular.ttf" font-size))
    (set! codepoints-count (make-ftype-pointer int (foreign-alloc (ftype-sizeof int))))
    (set! text-pics (make-fragments-from-text "你好呀，好久不见啦？" 50))
    ))

(define make-animation
  (lambda (animator)
    (lambda (reg)
      (let animating ([progress 0.0])
	(BeginDrawing)
	(ClearBackground BLACK)
	(((animator progress) reg))
	(EndDrawing)
	(unless (WindowShouldClose)
	  (animating (+ progress 0.1)))))))

(define walk-animator
  (lambda (frag)
    (lambda (progress)
      (lambda (reg)
	(lambda ()
	  (((move frag `(,progress . ,(* 5 (sin (* progress 0.1))))) reg)))))))

(define sequence-animator
  (lambda frags
    (let ([len (length frags)])
      (lambda (progress)
	(list-ref frags (min (1- len) (exact (floor (/ progress 10)))))))))

(define static-animator
  (lambda (frag)
    (lambda (progress)
      frag)))

(define overlay-animator
  (lambda anis
    (lambda (progress)
      (apply overlay-fragment
	     (map (lambda (ani) (ani progress)) anis)))))

(define main
  (lambda ()
    (InitWindow (GetScreenWidth) (GetScreenHeight) "TEST")
    (test-init)
    (let* ([whole-region (make-region 0.0 0.0 (* (GetScreenWidth) 1.0)
				      (* (GetScreenHeight) 1.0))]
	   [ani (make-animation
		 (overlay-animator
		  (static-animator bg-pic)
		  (static-animator char-pic)
		  (apply sequence-animator (map dialogue-locate text-pics)))
		 )])
      (ani whole-region)
      (CloseWindow))))
