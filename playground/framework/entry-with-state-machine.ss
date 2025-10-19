(define-record-type state
  (fields
   type events))
(define-record-type event
  (fields predicate transfer))

; start game, load game, gallery, config, endgame
(define main-menu
  (make-state 'main-menu
	      (list start-game load-game enter-gallery enter-config exit-game)))

(define start-game
  (make-event
   (lambda (state)
     (assert (memv (state-type state) '(main-menu)))
     (mouse-button-clicked? 'start-game))
   (lambda (state) game-playing)))

(define gaming
  (make-state 'gaming
	      (list next-frame save-game load-game enter-config back-to-main-menu skip-text start-auto-mode overview-backlog jump-previous-choice jump-next-choice replay-voice hide-dialogbox)))

(define load-game
  (make-event
   (lambda (st)
     (assert (memv (state-type st) '(main-menu gaming)))
     (mouse-button-clicked? 'load-game))
   (lambda (state)
     (case (state-type state)
       [(main-menu) (set! load-game-back back-to-main-menu)]
       [(gaming) (set! load-game-back back-to-game)])
     load-screen)))

(define load-screen
  (make-state 'load-screen
	      (list load-game-back))) 
      
(define replica
  (lambda ()
    (let loop ([state 'title])
      
