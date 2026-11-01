(library (game picture)
  (export default fade composite scale at shaded beside above)
  (import (chezscheme)
	  (ffi raylib binding)
	  (game resource) ;texture
	  (game raylib render)
	  (game window)
	  (game type)
	  (game color))

  (define default
    (lambda (tex)
      (lambda (f)			; picture理应只关心frame
	(clear-background black)
	(draw-texture tex f))))

  (define scale
    (lambda (pic times)
      (lambda (f)
	(let ([dest (frame-dest f)])
	  (let-values ([(x y w h) (rectangle-values dest)])
	    (pic (frame-change-dest f (make-rectangle x y (* w times) (* h times)))))))))

  (define at
    (lambda (pic fn-xy)  ;fn-xy 是一个输入x，y返回(values x y)的函数
      (lambda (f)
	(let ([dest (frame-dest f)])
	  (let*-values ([(x y w h) (rectangle-values dest)]
			[(x-new y-new) (fn-xy x y)])
	    (pic (frame-change-dest f (make-rectangle x-new y-new w h))))))))

  (define beside
    (case-lambda
      [(left right) (beside 0.5 left right)]
      [(ratio left right)
       (lambda (f)
	 (let ([dest (frame-dest f)])
           (let-values ([(x y w h) (rectangle-values dest)])
             (let* ([lw (* w ratio)]
                    [rw (- w lw)])
               (left  (frame-change-dest f (make-rectangle x y lw h)))
               (right (frame-change-dest f (make-rectangle (+ x lw) y rw h)))))))]))

  (define above
    (case-lambda
      [(top bottom) (above 0.5 top bottom)]
      [(ratio top bottom)
       (lambda (f)
	 (let ([dest (frame-dest f)])
           (let-values ([(x y w h) (rectangle-values dest)])
             (let* ([th (* h ratio)]
                    [bh (- h th)])
               (top    (frame-change-dest f (make-rectangle x y w th)))
               (bottom (frame-change-dest f (make-rectangle x (+ y th) w bh)))))))]))
  
  (define composite
    (lambda pics
      (lambda (f)
	(for-each (lambda (p) (p f)) pics))))

  (define fade
    (lambda (pic alpha)
      (assert (<= 0 alpha 1.0))
      (lambda (f)
	(let* ([t (frame-tint f)])
	  (pic (frame-change-tint f (color-alpha t alpha)))))))

  (define to-int (lambda (x) (inexact->exact (round x))))
  
  (define shaded
    (let ([rt-pool (make-hashtable equal-hash equal?)]
	  [float-address (let ([addrs (make-hashtable string-hash string=?)])
			   (lambda (key)
			     (if (hashtable-contains? addrs key)
				 (hashtable-ref addrs key #f)
				 (let ([addr (foreign-alloc (ftype-sizeof float))])
				   (hashtable-set! addrs key addr)
				   addr))))])
      (lambda (sh kv-list)
	(let-values ([(pic-kv-list other-kv-list) (partition (lambda (kv) (procedure? (cdr kv))) kv-list)])
	  (lambda (f)
	    (let ([s (shader-data sh)]
		  [locs (shader-locations sh)]
		  [dest (frame-dest f)])
	      (let-values ([(x y w h) (rectangle-values dest)])
		(for-each (lambda (kv)
			    (let ([name (car kv)])
			      (unless (hashtable-contains? locs name)
				(hashtable-set! locs name (GetShaderLocation s name))))) kv-list)
		(for-each (lambda (pic-kv)
			    (let* ([name (car pic-kv)]
				   [pic-for-val (cdr pic-kv)]
				   [rt-key (list name (to-int w) (to-int h))]
				   [loc (hashtable-ref locs name #f)])
			      (let ([rt (if (hashtable-contains? rt-pool rt-key)
					    (hashtable-ref rt-pool rt-key #f)
					    (let ([rt-new (LoadRenderTexture (to-int w) (to-int h))])
					      (hashtable-set! rt-pool rt-key rt-new)
					      rt-new))])
				(BeginTextureMode rt)
				(clear-background black)
				(pic-for-val f)
				(EndTextureMode))))
			  pic-kv-list)
		(BeginShaderMode s)
		(for-each
                 (lambda (pic-kv)
                   (let* ([name (car pic-kv)]
                          [rt-key (list name (to-int w) (to-int h))]
                          [loc (hashtable-ref locs name #f)]
                          [rt (hashtable-ref rt-pool rt-key #f)])
                     (SetShaderValueTexture s loc (ftype-&ref RenderTexture (texture) rt))))
                 pic-kv-list)
		(for-each
		 (lambda (other-kv)
		   (let* ([name (car other-kv)]
			  [val (cdr other-kv)]
			  [loc (hashtable-ref locs name #f)])
		     (cond
		      [(texture? val) (SetShaderValueTexture s loc (texture-data val))]
		      [(inexact? val)
		       (let ([ptr (float-address name)])
			 (foreign-set! 'float ptr 0 val)
			 (SetShaderValue s loc ptr SHADER_UNIFORM_FLOAT))])))
		 other-kv-list)
		(draw-texture (color->texture blank) f)
		(EndShaderMode))))))))
  )
