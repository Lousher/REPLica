(library (game raylib audio)
  (export play-music set-music-volume!)
  (import (chezscheme)
	  (game resource)
	  (ffi raylib binding))

  (define-syntax ftype-alloc
    (syntax-rules ()
      [(_ type)
       (make-ftype-pointer type (foreign-alloc (ftype-sizeof type)))
       ]))

  (define play-music
    (lambda (mus)
      (let ([m (music-data mus)])
	(if (IsMusicStreamPlaying m)
	    (UpdateMusicStream m)
	    (PlayMusicStream m)))))

  (define set-music-volume!
    (lambda (mus v)
      (let ([m (music-data mus)])
	(when m
	  (SetMusicVolume m v)))))

  )
