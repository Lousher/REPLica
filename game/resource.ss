(library (game resource)
  (export bundle bundle? make-bundle bundle-id bundle-resources
	  texture texture? make-texture texture-name texture-data texture-data-set! texture-source texture-source-set!
	  music music? make-music music-name music-data music-data-set!
	  shader shader? make-shader shader-fs shader-vs shader-data shader-data-set! shader-locations)
  (import (chezscheme)
	  )
  					; 每个bundle都是stage需要的资源聚合，用DAG表示其所有资源加载操作，用唯一标识符确定
  (define-record-type bundle
    (fields id resources))

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
    (fields fs vs (mutable data) locations)
    (protocol
     (lambda (new)
       (lambda (fs vs)
	 (let ([locs (make-hashtable string-hash string=?)])
	   (new fs vs #f locs))))))
  
  )
