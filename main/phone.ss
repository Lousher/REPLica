(define phone-loader
  (lambda (phone-w phone-h)
    (let* ([w (GetScreenWidth)]
	   [h (GetScreenHeight)]
	   [phone-rt (LoadRenderTexture (exact phone-w) (exact phone-h))]
	   [phone-tex (RenderTexture-texture phone-rt)]
	   [x (/ (- w phone-w) 2.0)]
	   [y (/ (- h phone-h) 2.0)]
	   [x-in (- (exact (floor x)) 10)]
	   [y-in (+ (exact (floor y)) 20)]
	   [round-rec (make-Rectangle 0.0 0.0 (inexact phone-w) (inexact phone-h))]
	   [tex-w (+ (exact phone-w) 20)]
	   [tex-h (- (exact phone-h) 40)]
	   [tex-rect (make-Rectangle 0.0 0.0 (* 1.0 phone-w) (* -1.0 phone-h))]
	   [ori-vec (make-Vector2 x y)]
	   [screen-tex #f])
      (case-lambda
	[(phone-img-path)
	 (let ([img (LoadImage phone-img-path)])
	   (ImageResize img tex-w tex-h)
	   (let ([tex (LoadTextureFromImage img)])
	     (set! screen-tex tex)
	     (UnloadImage img)
	     (BeginTextureMode phone-rt)
	     (DrawRectangleRoundedLinesEx round-rec 0.25 8 2.0 LIGHTGRAY)
	     (DrawRectangleRounded round-rec 0.25 8 BLACK)
	     (DrawTexture tex -10 20 WHITE)
	     (EndTextureMode)
	     (case-lambda
	       [(state)
		(DrawTextureRec phone-tex tex-rect ori-vec WHITE)]
	       [(x! y!)
		(begin
		  (Vector2-x-set! ori-vec (x! x))
		  (Vector2-y-set! ori-vec (y! y))
		  )])))]
	[()
	 (begin
	   (foreign-free (ftype-pointer-address round-rec))
	   (foreign-free (ftype-pointer-address tex-rect))
	   (foreign-free (ftype-pointer-address ori-vec))	   
	   (UnloadTexture screen-tex)
	   (UnloadRenderTexture phone-rt))]))))

(define phone-show
  (lambda (animator)
    (let ([frag1 (animator 0.0)]
	  [y-start 500])
      (lambda (passed)
	(let* ([y! (lambda (y) (max y (- y-start (* 600 passed))))])
	  (frag1 (lambda (x) x) y!)
	  (animator passed))))))



