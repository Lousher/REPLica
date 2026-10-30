(library (game resource)
  (export bundle bundle? make-bundle bundle-id bundle-resources
	  texture texture? make-texture texture-name texture-data texture-data-set!
	  music music? make-music music-name music-data music-data-set! music-playing? music-playing?-set!)
  (import (chezscheme))
  					; 每个bundle都是stage需要的资源聚合，用DAG表示其所有资源加载操作，用唯一标识符确定
  (define-record-type bundle
    (fields id resources))

  (define-record-type texture
    (fields name
	    (mutable data))
    (protocol
     (lambda (new)
       (lambda (n)
	 (new n #f)))))

  (define-record-type music
    (fields name
	    (mutable data)
	    (mutable playing?))
    (protocol
     (lambda (new)
       (lambda (n)
	 (new n #f #f)))))
  )
