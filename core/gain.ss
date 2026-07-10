(library (core gain)
  (export sound->gain pan-left pan-right pan-set! pause)
  (import
   (chezscheme)
   (core type)
   (core channel)
   (ffi raylib binding))

  (define *BUS* (make-parameter 1.0))

  (define sound->gain
    (lambda (so)
      (lambda (ch)
	(let ([so-fptr (sound-pointer so)])
	  (when so-fptr
	    (unless (IsSoundPlaying so-fptr) (PlaySound so-fptr))
	    (when (IsSoundPlaying so-fptr)
	      (unless (channel-playing? ch)
		(PauseSound so-fptr)))
	    (SetSoundVolume so-fptr (* (channel-volume ch) (*BUS*)))
	    (SetSoundPan so-fptr (channel-pan ch))
	    (SetSoundPitch so-fptr (channel-pitch ch)))))))

  (define pause
    (lambda (gain)
      (lambda (ch)
	(let ([vol (channel-volume ch)]
	      [pit (channel-pitch ch)]
	      [pan (channel-pan ch)])
	  (let ([new-ch (make-channel vol pit pan)])
	    (channel-playing?-set! new-ch #f)
	    (gain new-ch)))
	)))

  (define pan-left
    (lambda (gain)
      (lambda (ch)
	(let ([vol (channel-volume ch)]
	      [pit (channel-pitch ch)])
	  (gain (make-channel vol pit -1.0)))
	)
      ))

  (define pan-right
    (lambda (gain)
      (lambda (ch)
	(let ([vol (channel-volume ch)]
	      [pit (channel-pitch ch)])
	  (gain (make-channel vol pit 1.0)))
	)
      ))

  (define pan-set!
    (lambda (gain p)
      (lambda (ch)
	(let ([vol (channel-volume ch)]
	      [pit (channel-pitch ch)])
	  (gain (make-channel vol pit p))))))
  )
