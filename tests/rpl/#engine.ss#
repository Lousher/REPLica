(library-directories "main/")

(import (chezscheme)
        (raylib ffi)
        (raylib constant)
        (vm main)
        (vm asm)
        (rpl scene)
        (rpl render))

(define-values (test-code test-constants)
  (asm
    ;; 显示背景 (假设你的目录里有张 bg.png)
   (LOADK 0 "a.png")
   (LOADK 1 0.0)
   (LOADK 2 0.0)
   (SHOW 0 1 2)   

    ;; 显示人物 (假设你的目录里有张 alice.png)
   (LOADK 3 "b.png")
   (LOADK 4 0.0)
   (LOADK 5 0.0)
   (LOADK 20 10)
   (SETZ 20)
   (SHOW 3 4 5)

    ;; 准备对话框 ID 和文字
   (LOADK 6 "DIALOG_NODE")
   (LOADK 7 "This is the first sentence...")
   (TEXT 6 7) ;; VM 会去场景树找 DIALOG_NODE 并更新它

   ;; 逻辑挂起，等待玩家点击
   (WAIT)

   ;; 玩家点击后，VM 醒来执行下一句
   (LOADK 8 "Now VM is Decoupled with render")
   (TEXT 6 8)

   (WAIT)
   (LOADK 9 "NEW_DIALOG")
   (LOADK 10 "New sentence in new dialog")
   (TEXT 9 10)
   (WAIT)))

(define start
  (lambda ()
    (init)
    (let ([vm (make test-code test-constants)])
      (let loop ()
	(unless (WindowShouldClose)
	  (when (IsMouseButtonPressed MOUSE_BUTTON_LEFT)
	    (when (not (state-running? vm))
	      (state-running?-set! vm #t)))

	  (run vm) ; changing scene-tree silently

	  (BeginDrawing)
	  (ClearBackground BLACK)
	  (draw (state-scene-root vm) 0.0 0.0 1.0)
	  (EndDrawing)
	  (loop))))
    (uninit)))
