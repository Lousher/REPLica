(library (game resource)
  (export loader
	  texture texture? make-texture texture-name texture-data texture-data-set! texture-source texture-source-set!
	  music music? make-music music-name music-data music-data-set!
	  shader shader? make-shader shader-fs shader-vs shader-data shader-data-set! shader-locations
	  file-image? file-music? directory-walk load-directory resource-fuzzy-query)
  (import (chezscheme)
	  (game tool)
	  (game type)
	  (ffi raylib binding))
  ; 每个bundle都是stage需要的资源聚合，用DAG表示其所有资源加载操作，用唯一标识符确定

  (define-record-type texture
    (fields name
	    (mutable data)
	    (mutable source))
    (protocol
     (lambda (new)
       (case-lambda
	 [(n)
	  (new n #f #f)]
	 [(n d s) (new n d s)]))))

  (define-record-type music
    (fields name
	    (mutable data))
    (protocol
     (lambda (new)
       (lambda (n)
	 (new n #f)))))

  (define-record-type shader
    (fields vs fs (mutable data) locations)
    (protocol
     (lambda (new)
       (lambda (vs fs)
	 (let ([locs (make-hashtable string-hash string=?)])
	   (new vs fs #f locs))))))
  
  #| helper function |#
  (define directory-list*
    (lambda (dir)
      (map (lambda (f) (path-build dir f)) (directory-list dir))))

  (define file-image?
    (let ([image-exts '(png jpg jpeg bmp tga gif psd hdr pic pnm qoi)])
      (lambda (f)
	(and (memq (string->symbol (path-extension f)) image-exts)
	     (file-regular? f)))))

  (define file-shader?
    (lambda (f)
      (let ([exts '(fs vs)])
	(and (memq (string->symbol (path-extension f)) exts)
             (file-regular? f)))))

  (define file-music?
    (let ([exts '(wav ogg mp3 flac qoa xm mod)])
      (lambda (f)
	(and (memq (string->symbol (path-extension f)) exts)
	     (file-regular? f)))))

  (define directory-walk
    (lambda (dir)
      (cond
       [(file-regular? dir) (list dir)]
       [(file-symbolic-link? dir) '()]
       [else
	(let ([entries (directory-list* dir)])
	  (let-values ([(dirs others) (partition file-directory? entries)])
	    (append (filter file-regular? others)
		    (apply append (map directory-walk dirs)))))])))


  (define FILES '())
  (define FUZZY_LEARED (make-hashtable equal-hash equal?))
  (define RESOURCES (make-hashtable string-hash string=?))
  
  (define resource-fuzzy-query
    (lambda query
      (let ([str (if (hashtable-contains? FUZZY_LEARED query)
		     (hashtable-ref FUZZY_LEARED query #f)
		     (let ([matched (apply zf FILES query)])
		       (hashtable-set! FUZZY_LEARED query matched)
		   matched))])
	(if str
	    (hashtable-ref RESOURCES str #f)
	    #f))))
  
  (define file-name
    (lambda (path)
      (path-last (path-root path))))
  
  (define load-directory
    (lambda (dir)
      (unless (file-directory? dir)
	(error 'load-directory "[Resource] Not a directory" dir))
      (let* ([files (directory-walk dir)]
	     [imgs (filter file-image? files)]
	     [mucs (filter file-music? files)]
	     [shs (filter file-shader? files)])
	(set! FILES (append imgs mucs shs))
	(for-each (lambda (img) (hashtable-set! RESOURCES img (make-texture img))) imgs)
	(for-each (lambda (muc) (hashtable-set! RESOURCES muc (make-music muc))) mucs)
	(for-each (lambda (sh) (hashtable-set! RESOURCES sh (make-shader (zf shs (format "~a.~a" (file-name sh) 'vs))
									 (zf shs (format "~a.~a" (file-name sh) 'fs))))) shs)
	)))

    #| helper |#
  (define optimize-texture
    (lambda (T)
      (GenTextureMipmaps T)
      (SetTextureFilter T TEXTURE_FILTER_TRILINEAR)))
  
  (define Texture-width
    (lambda (T)
      (ftype-ref Texture (width) T)))
  (define Texture-height
    (lambda (T)
      (ftype-ref Texture (height) T)))

  (define loader
    (lambda (bun)
      (let* ([texs (filter texture? bun)]
	     [mucs (filter music? bun)]
	     [shs (filter shader? bun)]
	     [texs-unload (filter (lambda (t) (not (texture-data t))) texs)]
	     [mucs-unload (filter (lambda (t) (not (music-data t))) mucs)]
	     [shs-unload (filter (lambda (t) (not (shader-data t))) shs)])
	(for-each
	 (lambda (tex)
	   (let* ([name (texture-name tex)]
		  [t (LoadTexture name)]
		  [w (Texture-width t)]
		  [h (Texture-height t)])
	     (optimize-texture t)
	     (texture-data-set! tex t)
	     (texture-source-set! tex (make-rectangle 0.0 0.0
						      (inexact w)
						      (inexact h)))))
	 texs-unload)
	(for-each
	 (lambda (muc)
	   (let* ([name (music-name muc)]
		  [m (LoadMusicStream name)])
	     (music-data-set! muc m)))
	 mucs-unload)
	(for-each
	 (lambda (sh)
	   (let* ([fs (shader-fs sh)]
		  [vs (shader-vs sh)]
		  [s (LoadShader vs fs)])
	     (unless (IsShaderValid s)
	       (error 'load (format "[Loader] ~a and ~a cannot load shader" fs vs)))
	     (shader-data-set! sh s)))
	 shs-unload)
	)))
  )
