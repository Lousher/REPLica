(library (game clip) ;和picture一样，在
  (export plain)
  (import (chezscheme)
	  (game resource)
	  (game window) ;广义上的window
	  (game raylib audio))

  (define plain
    (lambda (mus)
      (lambda (cnl)   ; ← 接收 channel
	(set-music-volume mus (channel-volume cnl))
	(set-music-pan    mus (channel-pan cnl))
	(set-music-pitch  mus (channel-pitch cnl))
	(play-music mus))))
  
  )
