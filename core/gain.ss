(library (core gain)
  (export sound->gain pan-left pan-right pan-set!)
  (import
   (chezscheme)
   (core type)
   (core channel)
   (ffi raylib binding))

  (define *BUS* (make-parameter 1.0))

  (define sound->gain
    (lambda (so)
      (let ([started #f])
	(lambda (ch)
	  (let ([so-fptr (sound-pointer so)])
	    (when so-fptr
	      (unless started
		(PlaySound so-fptr)
		(set! started #t))
	      (SetSoundVolume so-fptr (* (channel-volume ch) (*BUS*)))
	      (SetSoundPan so-fptr (channel-pan ch))
	      (SetSoundPitch so-fptr (channel-pitch ch))))))))

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
