(library (core channel)
  (export
   *CHANNEL*
   channel? make-channel
   channel-volume channel-volume-set!
   channel-pitch channel-pitch-set!
   channel-pan channel-pan-set!
   )
  (import
   (chezscheme)
   )

  (define *CHANNEL* (make-parameter #f))
  
  (define-record-type channel
    (fields
     (mutable volume)
     (mutable pitch)
     (mutable pan)
     )
    (protocol
     (lambda (new)
       (case-lambda
	 [()
	  (new 1.0 1.0 0.0)]
	 [(vol pit pan)
	  (new vol pit pan)]))))
  )
