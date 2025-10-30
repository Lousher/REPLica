(load-shared-object "libraylib.5.5.0.dylib")
(load-shared-object "raylib.ffi.so")
(load "raylib.ffi.ss")
(load "raylib.constant.ss")

					; primitive: regin renderer
(define-record-type region
  (fields
   x
   y
   width
   height))

(define region->Rectangle
  (lambda (reg)
    (let ([x (region-x reg)] [y (region-y reg)]
	  [w (region-width reg)] [h (region-height reg)])
      (make-Rectangle (exact->inexact x)
		      (exact->inexact y)
		      (exact->inexact w)
		      (exact->inexact h)))))

(define make-picture
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

; picture
(define flat-vertical
  (lambda pics
    (let ([count (length pics)])
      (lambda (reg)
	(let ([w-seg (* (/ (region-width reg) count) 1.0)])
	  (lambda ()
	    (for-each
	     (lambda (pic index)
	       (let ([x (* index w-seg)] [y 0] [w w-seg] [h (region-height reg)])
		 (let ([rect-index (make-region x y w h)])
		   ((pic rect-index)))))
	     pics
	     (iota count))))))))
(define overlay-picture
  (lambda (backend-pic frontend-pic)
    (lambda (reg)
      (lambda ()
	((backend-pic reg))
	((frontend-pic reg))))))
(define move
  (lambda (pic offset)
    (lambda (reg)
      (let ([x-offset (car offset)] [y-offset (cdr offset)]
	    [x (region-x reg)] [y (region-y reg)]
	    [w (region-width reg)] [h (region-height reg)])
	(let ([rect-moved (make-region (+ x x-offset) (+ y y-offset) w h)])
	  (lambda ()
	    ((pic rect-moved))))))))


(define test-init
  (lambda ()
    (set! texture1 (LoadTexture "../assets/bg/yuwen.bedroom.morning.png"))
    (set! texture2 (LoadTexture "../assets/character/0896.png"))
    (set! bg-pic (make-picture texture1))
    (set! char-pic (make-picture texture2))
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
  (lambda (pic)
    (lambda (progress)
      (lambda (reg)
	(lambda ()
	  (((move pic `(,(+ -800 progress) . ,(* 5 (sin (* progress 0.05))))) reg)))))))

(define static-animator
  (lambda (pic)
    (lambda (progress)
      pic)))

(define overlay-animator
  (lambda (ani-back ani-front)
    (lambda (progress)
      (overlay-picture
      (ani-back progress)
      (ani-front progress)))))

(define main
  (lambda ()
    (InitWindow (GetScreenWidth) (GetScreenHeight) "TEST")
    (test-init)
    (let* ([whole-region (make-region 0.0 0.0 (* (GetScreenWidth) 1.0)
				      (* (GetScreenHeight) 1.0))]
	   [ani (make-animation
		 (overlay-animator
		  (static-animator bg-pic)
		  (walk-animator char-pic)))])
      (ani whole-region)
      (CloseWindow))))


