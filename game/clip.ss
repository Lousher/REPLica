(library (game clip) ;和picture一样，在
  (export plain fade-in)
  (import (chezscheme)
	  (game resource)
	  (game raylib audio)
	  (ffi raylib binding))

  (define plain
    (lambda (mus)
      (lambda (win);抽象意义上的”窗口“
	(play-music mus))))

  (define fade-in
    (lambda (mus duration)
      (set-music-volume! mus 0.0)
      (let ([elapsed 0.0])
	(lambda (win)
	  (play-music mus)
	  (set! elapsed (+ elapsed (GetFrameTime)))
	  (set-music-volume! mus (min 1.0 (/ elapsed duration)))))))

  )
