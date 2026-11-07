(library (game clip) ;和picture一样，在
  (export clip? clip-player clip-deps
   dry)
  (import (chezscheme)
	  (game context)
	  (game raylib audio))

  (define-record-type clip
    (fields player deps))

  (define dry
    (lambda (mus)
      (make-clip
       (lambda (cnl)			; ← 接收 channel
	 (set-music-volume mus (channel-volume cnl))
	 (set-music-pan    mus (channel-pan cnl))
	 (set-music-pitch  mus (channel-pitch cnl))
	 (play-music mus))
       (list mus))))

  )
