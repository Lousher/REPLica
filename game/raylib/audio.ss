(library (game raylib audio)
  (export play-music set-music-volume
	  set-music-pan  set-music-pitch)
  (import (chezscheme)
	  (game resource)
	  (ffi raylib binding))

  (define play-music
    (lambda (mus)
      (let ([m (music-data mus)])
	(if (IsMusicStreamPlaying m)
	    (UpdateMusicStream m)
	    (PlayMusicStream m)))))

  (define set-music-volume
    (lambda (mus v)
      (let ([m (music-data mus)])
	(when m
	  (SetMusicVolume m v)))))

  (define set-music-pan
    (lambda (mus p)
      (let ([m (music-data mus)])
	(when m (SetMusicPan m p)))))

  (define set-music-pitch
    (lambda (mus p)
      (let ([m (music-data mus)])
	(when m (SetMusicPitch m p)))))

  )
