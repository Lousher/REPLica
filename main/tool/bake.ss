(library (tool bake)
  (export bake-sdf)
  (import (chezscheme)
	  (raylib ffi)
	  (raylib constant))

  ;; input sorted , unique codepoint/integer list, output bytevector for FFI/C call
  (define codepoints->bytevector
    (lambda (codepoints-list)
      (let* ([len (length codepoints-list)]
             ;; 1. 每个 32 位整数 (int) 占用 4 字节
             [bv (make-bytevector (* len 4) 0)])
	;; 2. 使用命名 let (Named Let) 进行高效循环
	(let loop ([i 0] [lst codepoints-list])
          (if (null? lst)
              bv ;; 3. 递归出口：列表处理完毕，返回填充好的 bytevector
              (begin
		;; 4. 核心：将码点以“本地字节序”写入 bytevector
		;; 注意：偏移量是 i * 4，因为每个元素占 4 字节
		(bytevector-s32-native-set! bv (* i 4) (car lst))
		;; 5. 递归调用：处理下一个字符，偏移索引加 1
		(loop (+ i 1) (cdr lst))))))))

  (define s32->bv
    (lambda (x)
      (let ([bv (make-bytevector 4)])
        (bytevector-s32-set! bv 0 x (endianness little))
        bv)))

  (define f32->bv
    (lambda (x)
      (let ([bv (make-bytevector 4)])
        (bytevector-ieee-single-set! bv 0 x (endianness little))
        bv)))

  (define bake-sdf
    (lambda (ttf-path output-png output-bin codepoints size padding)
      (let ([cp-count (length codepoints)]
            [cp-bv (codepoints->bytevector codepoints)])
        ;; 使用原生 I/O 读取 TTF [cite: 13]
        (let* ([font-bv (call-with-port (open-file-input-port ttf-path) get-bytevector-all)]
               [font-data-size (bytevector-length font-bv)]
               ;; 加载 SDF 数据 [cite: 14, 54]
               [glyphs-ptr (LoadFontData font-bv font-data-size size cp-bv cp-count FONT_SDF)])
          (if (not glyphs-ptr)
              (error 'bake-sdf "无法加载字体数据")
              (begin
                (display "正在生成图集...\n")
                ;; 准备二级指针盒子 [cite: 33, 55]
                (let ([recs-box (make-ftype-pointer *Rectangle (foreign-alloc (ftype-sizeof *Rectangle)))]) 
                  (let ([atlas-img (GenImageFontAtlas glyphs-ptr recs-box cp-count size padding 1)])
                    ;; 获取真正的 Rectangle 数组指针 [cite: 33]
                    (let ([recs-ptr (ftype-ref *Rectangle () recs-box)])
                      ;; 导出图片 [cite: 56]
                      (ExportImage atlas-img output-png)
                      (display (string-append "贴图已保存至: " output-png "\n"))
                      ;; 写入二进制元数据 [cite: 17, 18]
                      (display "正在写入二进制元数据...\n")
                      (let ([p (open-file-output-port output-bin (file-options no-fail) (buffer-mode block) #f)])
                        (dynamic-wind
                          (lambda () #f)
                          (lambda ()
                            ;; 写入总字数 (4 bytes)
                            (put-bytevector p (s32->bv cp-count))
                            ;; 遍历并写入每个字形的度量数据 [cite: 19, 39]
                            (let loop ([i 0])
                              (when (< i cp-count)
				(when (zero? (modulo i 500))
                                  (display (format "  已处理 ~a / ~a 字\n" i cp-count)))
                                ;; Codepoint
                                (put-bytevector p (s32->bv (ftype-ref GlyphInfo (value) glyphs-ptr i)))
                                ;; Rectangle (x, y, w, h)
                                (put-bytevector p (f32->bv (ftype-ref Rectangle (x) recs-ptr i)))
                                (put-bytevector p (f32->bv (ftype-ref Rectangle (y) recs-ptr i)))
                                (put-bytevector p (f32->bv (ftype-ref Rectangle (width) recs-ptr i)))
                                (put-bytevector p (f32->bv (ftype-ref Rectangle (height) recs-ptr i)))
                                ;; Layout (offX, offY, advX)
                                (put-bytevector p (s32->bv (ftype-ref GlyphInfo (offsetX) glyphs-ptr i)))
                                (put-bytevector p (s32->bv (ftype-ref GlyphInfo (offsetY) glyphs-ptr i)))
                                (put-bytevector p (s32->bv (ftype-ref GlyphInfo (advanceX) glyphs-ptr i)))
                                (loop (+ i 1)))))
                          (lambda () (close-output-port p))))
                      ;; 内存清理 [cite: 25, 29, 50]
                      (UnloadImage atlas-img)
                      (UnloadFontData glyphs-ptr cp-count)
		      (foreign-free (ftype-pointer-address recs-box))
                      (foreign-free (ftype-pointer-address recs-ptr))
                      (display "烘焙完成！\n"))))))))))
  )
