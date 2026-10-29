(library (ffi rini binding)
  (export
   ;; ftype 定义（必须导出，因为 rini_data 按值传参）
   rini_entry
   rini_data

   ;; 加载与保存
   rini_load
   rini_load_full
   rini_load_from_memory
   rini_save
   rini_save_to_memory
   rini_unload

   ;; 读取
   rini_get_value
   rini_get_value_text
   rini_get_value_description
   rini_get_value_fallback
   rini_get_value_text_fallback

   ;; 写入
   rini_set_comment_line
   rini_set_value
   rini_set_value_text
   rini_set_value_description)

  (import (chezscheme))

  (define-ftype rini_entry
    (struct
      [key     (array 64 integer-8)]
      [text    (array 256 integer-8)]
      [desc    (array 256 integer-8)]
      [is_text boolean]))

  (define-ftype rini_data
    (struct
      [entries  (* rini_entry)]
      [count    unsigned-32]
      [capacity unsigned-32]))

  ;; ==================================================================
  ;; 加载与保存
  ;; ==================================================================

  ;; rini_data rini_load(const char *file_name)
  (define rini_load
    (let ([proc (foreign-procedure
		 #f "rini_load"
		 (string)
		 (& rini_data))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rini_data
			(foreign-alloc (ftype-sizeof rini_data)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; rini_data rini_load_full(const char *file_name)
  (define rini_load_full
    (let ([proc (foreign-procedure
		 #f "rini_load_full"
		 (string)
		 (& rini_data))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rini_data
			(foreign-alloc (ftype-sizeof rini_data)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; rini_data rini_load_from_memory(const char *text)
  (define rini_load_from_memory
    (let ([proc (foreign-procedure
		 #f "rini_load_from_memory"
		 (string)
		 (& rini_data))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rini_data
			(foreign-alloc (ftype-sizeof rini_data)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; void rini_save(rini_data data, const char *file_name)
  (define rini_save
    (foreign-procedure "rini_save"
		       ((& rini_data) string)
		       void))

  ;; char *rini_save_to_memory(rini_data data)
  ;; NOTE: 返回指向内部 static 缓冲区的指针，string 返回类型会让 Chez 复制成 Scheme 字符串
  (define rini_save_to_memory
    (foreign-procedure "rini_save_to_memory"
		       ((& rini_data))
		       string))

  ;; void rini_unload(rini_data *data)
  (define rini_unload
    (foreign-procedure "rini_unload"
		       ((* rini_data))
		       void))

  ;; ==================================================================
  ;; 读取
  ;; ==================================================================

  ;; int rini_get_value(rini_data data, const char *key)
  (define rini_get_value
    (foreign-procedure "rini_get_value"
		       ((& rini_data) string)
		       int))

  ;; const char *rini_get_value_text(rini_data data, const char *key)
  ;; NOTE: 返回内部数据指针，string 返回类型会复制为 Scheme 字符串，安全
  (define rini_get_value_text
    (foreign-procedure "rini_get_value_text"
		       ((& rini_data) string)
		       string))

  ;; const char *rini_get_value_description(rini_data data, const char *key)
  (define rini_get_value_description
    (foreign-procedure "rini_get_value_description"
		       ((& rini_data) string)
		       string))

  ;; int rini_get_value_fallback(rini_data data, const char *key, int fallback)
  (define rini_get_value_fallback
    (foreign-procedure "rini_get_value_fallback"
		       ((& rini_data) string int)
		       int))

  ;; const char *rini_get_value_text_fallback(rini_data data, const char *key,
  ;;                                           const char *fallback)
  (define rini_get_value_text_fallback
    (foreign-procedure "rini_get_value_text_fallback"
		       ((& rini_data) string string)
		       string))

  ;; ==================================================================
  ;; 写入（需要传 rini_data 指针）
  ;; ==================================================================

  ;; int rini_set_comment_line(rini_data *data, const char *comment)
  (define rini_set_comment_line
    (foreign-procedure "rini_set_comment_line"
		       ((* rini_data) string)
		       int))

  ;; int rini_set_value(rini_data *data, const char *key, int value, const char *desc)
  (define rini_set_value
    (foreign-procedure "rini_set_value"
		       ((* rini_data) string int string)
		       int))

  ;; int rini_set_value_text(rini_data *data, const char *key,
  ;;                         const char *text, const char *desc)
  (define rini_set_value_text
    (foreign-procedure "rini_set_value_text"
		       ((* rini_data) string string string)
		       int))

  ;; int rini_set_value_description(rini_data *data, const char *key, const char *desc)
  (define rini_set_value_description
    (foreign-procedure "rini_set_value_description"
		       ((* rini_data) string string)
		       int))
  )
