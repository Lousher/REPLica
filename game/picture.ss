(library (game picture)
  (export picture? picture-drawer picture-deps
	  default contain 
	  fade composite scale at shaded beside above)
  (import (chezscheme)
	  (ffi raylib binding)
	  (game resource) ;texture
	  (game raylib render)
	  (game world)
	  (game type)
	  (game color))

  (define-record-type picture
    (fields drawer deps)) ; id for identify the shape!

  #| default picture could be any combined |#
  (define default
    (lambda (tex)
      (make-picture
       (lambda (f)
	 (draw-texture tex f))
       (list tex))))

  #| show src in dest without changing ratio |#
  (define calculate-dest
    (lambda (dest src)
      (let-values ([(dx dy dw dh) (rectangle-values dest)]
		   [(sx sy sw sh) (rectangle-values src)])
	(let* ([src-ratio (/ sw sh)]
	       [dest-aspet (/ dw dh)]
	       [scale (if (> src-ratio dest-aspet)
			  (/ dw sw)
			  (/ dh sh))]
	       [nw (* sw scale)]
	       [nh (* sh scale)]
	       [nx (+ dx (/ (- dw nw) 2))]
	       [ny (+ dy (/ (- dh nh) 2))])
	  (make-rectangle nx ny nw nh)))))

  (define contain
    (lambda (tex)
      (make-picture
       (lambda (f)
	 (when (texture-source tex)
	   (let* ([src (texture-source tex)]
		  [dest (calculate-dest (frame-dest f) src)])
	     (draw-texture tex (frame-change-dest f dest)))))
       (list tex))))

  (define fade
    (lambda (pic alpha)
      (assert (<= 0 alpha 1.0))
      (make-picture
       (lambda (f)
	 ((picture-drawer pic)
	  (frame-change-tint f (color-alpha (frame-tint f) alpha))))
       (picture-deps pic))))

  (define scale
    (lambda (pic times)
      (make-picture
       (lambda (f)
	 (let ([dest (frame-dest f)])
	   (let-values ([(x y w h) (rectangle-values dest)])
	     ((picture-drawer pic)
	      (frame-change-dest f (make-rectangle x y (* w times) (* h times)))))))
       (picture-deps pic))))

  (define at
    (lambda (pic fn-xy)  ;fn-xy 是一个输入x，y返回(values x y)的函数
      (make-picture
       (lambda (f)
	 (let ([dest (frame-dest f)])
	   (let*-values ([(x y w h) (rectangle-values dest)]
			 [(x-new y-new) (fn-xy x y)])
	     ((picture-drawer pic) (frame-change-dest f (make-rectangle x-new y-new w h))))))
       (picture-deps pic))))

  (define beside
    (case-lambda
      [(left right) (beside 0.5 left right)]
      [(ratio left right)
       (make-picture
	(lambda (f)
	  (let ([dest (frame-dest f)])
            (let-values ([(x y w h) (rectangle-values dest)])
	      (let* ([lw (* w ratio)]
                     [rw (- w lw)])
		((picture-drawer left)  (frame-change-dest f (make-rectangle x y lw h)))
		((picture-drawer right) (frame-change-dest f (make-rectangle (+ x lw) y rw h)))))))
	(merge-deps (picture-deps left) (picture-deps right)))]))

  (define above
    (case-lambda
      [(top bottom) (above 0.5 top bottom)]
      [(ratio top bottom)
       (make-picture
	(lambda (f)
	  (let ([dest (frame-dest f)])
            (let-values ([(x y w h) (rectangle-values dest)])
	      (let* ([th (* h ratio)]
                     [bh (- h th)])
		((picture-drawer top) (frame-change-dest f (make-rectangle x y w th)))
		((picture-drawer bottom) (frame-change-dest f (make-rectangle x (+ y th) w bh)))))))
	(merge-deps (picture-deps top) (picture-deps bottom)))]))
  
  (define composite
    (lambda pics
      (make-picture
       (lambda (f)
	 (for-each (lambda (p) ((picture-drawer p) f)) pics))
       (apply merge-deps (map picture-deps pics)))))

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
	(let-values ([(pic-kv-list other-kv-list) (partition (lambda (kv) (picture? (cdr kv))) kv-list)])
	  (make-picture
	   (lambda (f)
	     (let ([s (shader-data sh)]
		   [locs (shader-locations sh)]
		   [dest (frame-dest f)])
	       (let-values ([(x y w h) (rectangle-values dest)])
		 (when s
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
				   ((picture-drawer pic-for-val)
				    (frame-change-dest
				     f
				     (make-rectangle 0.0 0.0 w h)))
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
		   (EndShaderMode)))))
	   (merge-deps ; picture的deps 和 texture本身的deps
	    (cons sh (map cdr (filter (lambda (kv) (texture? (cdr kv))) kv-list)))
	    (apply merge-deps (map (lambda (kv) (picture-deps (cdr kv))) pic-kv-list))))))))
  
  )
