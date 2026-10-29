(library (ffi rpng binding)
  (export
   ;; ---- ftype 定义（补充导出，用于构造按值结构体参数） ----
   rpng_chunk
   rpng_color
   rpng_palette

   ;; ---- 图像读写（文件） ----
   rpng_load_image
   rpng_load_image_indexed
   rpng_save_image
   rpng_save_image_indexed

   ;; ---- 图像读写（内存） ----
   rpng_load_image_from_memory
   rpng_load_image_indexed_from_memory
   rpng_save_image_to_memory
   rpng_save_image_indexed_to_memory

   ;; ---- 索引数据转换 ----
   rpng_unindex_image_data

   ;; ---- Chunk 操作（文件） ----
   rpng_chunk_count
   rpng_chunk_read
   rpng_chunk_read_all
   rpng_chunk_remove
   rpng_chunk_remove_ancillary
   rpng_chunk_write

   ;; ---- Chunk 写入辅助（文件） ----
   rpng_chunk_write_text
   rpng_chunk_write_comp_text
   rpng_chunk_write_gamma
   rpng_chunk_write_srgb
   rpng_chunk_write_time
   rpng_chunk_write_physical_size
   rpng_chunk_write_chroma

   ;; ---- Chunk 工具（文件） ----
   rpng_chunk_print_info
   rpng_chunk_check_all_valid
   rpng_chunk_combine_image_data
   rpng_chunk_split_image_data

   ;; ---- Chunk 操作（内存） ----
   rpng_chunk_count_from_memory
   rpng_chunk_read_from_memory
   rpng_chunk_read_all_from_memory
   rpng_chunk_remove_from_memory
   rpng_chunk_remove_ancillary_from_memory
   rpng_chunk_write_from_memory
   rpng_chunk_combine_image_data_from_memory
   rpng_chunk_split_image_data_from_memory)

  (import (chezscheme))

  (define-ftype rpng_chunk
    (struct
      [length int]
      [type   (array 4 integer-8)]
      [data   (* unsigned-8)]
      [crc    unsigned-32]))

  (define-ftype rpng_color
    (struct
      [r unsigned-8]
      [g unsigned-8]
      [b unsigned-8]
      [a unsigned-8]))

  (define-ftype rpng_palette
    (struct
      [color_count int]
      [colors (* rpng_color)]))

  ;; ==================================================================
  ;; 图像读写（文件）
  ;; ==================================================================

  ;; char *rpng_load_image(const char *filename, int *width, int *height,
  ;;                       int *color_channels, int *bit_depth)
  (define rpng_load_image
    (foreign-procedure "rpng_load_image"
		       (string (* int) (* int) (* int) (* int))
		       u8*))

  ;; char *rpng_load_image_indexed(const char *filename, int *width,
  ;;                               int *height, rpng_palette *palette)
  (define rpng_load_image_indexed
    (foreign-procedure "rpng_load_image_indexed"
		       (string (* int) (* int) (* rpng_palette))
		       u8*))

  ;; int rpng_save_image(const char *filename, const char *data,
  ;;                     int width, int height, int color_channels, int bit_depth)
  (define rpng_save_image
    (foreign-procedure "rpng_save_image"
		       (string u8* int int int int)
		       int))

  ;; int rpng_save_image_indexed(const char *filename, const char *indexed_data,
  ;;                             int width, int height, rpng_palette palette)
  (define rpng_save_image_indexed
    (foreign-procedure "rpng_save_image_indexed"
		       (string u8* int int (& rpng_palette))
		       int))

  ;; ==================================================================
  ;; 图像读写（内存）
  ;; ==================================================================

  ;; char *rpng_load_image_from_memory(const char *buffer, int *width, int *height,
  ;;                                   int *color_channels, int *bit_depth)
  (define rpng_load_image_from_memory
    (foreign-procedure "rpng_load_image_from_memory"
		       (u8* (* int) (* int) (* int) (* int))
		       u8*))

  ;; char *rpng_load_image_indexed_from_memory(const char *buffer, int *width,
  ;;                                           int *height, rpng_palette *palette)
  (define rpng_load_image_indexed_from_memory
    (foreign-procedure "rpng_load_image_indexed_from_memory"
		       (u8* (* int) (* int) (* rpng_palette))
		       u8*))

  ;; char *rpng_save_image_to_memory(const char *data, int width, int height,
  ;;                                 int color_channels, int bit_depth, int *output_size)
  (define rpng_save_image_to_memory
    (foreign-procedure "rpng_save_image_to_memory"
		       (u8* int int int int (* int))
		       u8*))

  ;; char *rpng_save_image_indexed_to_memory(const char *indexed_data, int width,
  ;;                                         int height, rpng_palette palette, int *output_size)
  (define rpng_save_image_indexed_to_memory
    (foreign-procedure "rpng_save_image_indexed_to_memory"
		       (u8* int int (& rpng_palette) (* int))
		       u8*))

  ;; ==================================================================
  ;; 索引数据转换
  ;; ==================================================================

  ;; char *rpng_unindex_image_data(char *indexed_data, int width, int height,
  ;;                               rpng_palette palette)
  (define rpng_unindex_image_data
    (foreign-procedure "rpng_unindex_image_data"
		       (u8* int int (& rpng_palette))
		       u8*))

  ;; ==================================================================
  ;; Chunk 操作（文件）
  ;; ==================================================================

  ;; int rpng_chunk_count(const char *filename)
  (define rpng_chunk_count
    (foreign-procedure "rpng_chunk_count"
		       (string)
		       int))

  ;; rpng_chunk rpng_chunk_read(const char *filename, const char *chunk_type)
  (define rpng_chunk_read
    (let ([proc (foreign-procedure
		 #f "rpng_chunk_read"
		 (string string)
		 (& rpng_chunk))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rpng_chunk
			(foreign-alloc (ftype-sizeof rpng_chunk)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; rpng_chunk *rpng_chunk_read_all(const char *filename, int *count)
  (define rpng_chunk_read_all
    (foreign-procedure "rpng_chunk_read_all"
		       (string (* int))
		       (* rpng_chunk)))

  ;; void rpng_chunk_remove(const char *filename, const char *chunk_type)
  (define rpng_chunk_remove
    (foreign-procedure "rpng_chunk_remove"
		       (string string)
		       void))

  ;; void rpng_chunk_remove_ancillary(const char *filename)
  (define rpng_chunk_remove_ancillary
    (foreign-procedure "rpng_chunk_remove_ancillary"
		       (string)
		       void))

  ;; void rpng_chunk_write(const char *filename, rpng_chunk data)
  (define rpng_chunk_write
    (foreign-procedure "rpng_chunk_write"
		       (string (& rpng_chunk))
		       void))

  ;; ==================================================================
  ;; Chunk 写入辅助（文件）
  ;; ==================================================================

  ;; void rpng_chunk_write_text(const char *filename, char *keyword, char *text)
  (define rpng_chunk_write_text
    (foreign-procedure "rpng_chunk_write_text"
		       (string string string)
		       void))

  ;; void rpng_chunk_write_comp_text(const char *filename, char *keyword, char *text)
  (define rpng_chunk_write_comp_text
    (foreign-procedure "rpng_chunk_write_comp_text"
		       (string string string)
		       void))

  ;; void rpng_chunk_write_gamma(const char *filename, float gamma)
  (define rpng_chunk_write_gamma
    (foreign-procedure "rpng_chunk_write_gamma"
		       (string float)
		       void))

  ;; void rpng_chunk_write_srgb(const char *filename, char srgb_type)
  (define rpng_chunk_write_srgb
    (foreign-procedure "rpng_chunk_write_srgb"
		       (string integer-8)
		       void))

  ;; void rpng_chunk_write_time(const char *filename, short year, char month,
  ;;                            char day, char hour, char min, char sec)
  (define rpng_chunk_write_time
    (foreign-procedure "rpng_chunk_write_time"
		       (string short integer-8 integer-8 integer-8 integer-8 integer-8)
		       void))

  ;; void rpng_chunk_write_physical_size(const char *filename, int pixels_unit_x,
  ;;                                     int pixels_unit_y, bool meters)
  (define rpng_chunk_write_physical_size
    (foreign-procedure "rpng_chunk_write_physical_size"
		       (string int int boolean)
		       void))

  ;; void rpng_chunk_write_chroma(const char *filename,
  ;;                              float white_x, float white_y,
  ;;                              float red_x, float red_y,
  ;;                              float green_x, float green_y,
  ;;                              float blue_x, float blue_y)
  (define rpng_chunk_write_chroma
    (foreign-procedure "rpng_chunk_write_chroma"
		       (string float float float float float float float float)
		       void))

  ;; ==================================================================
  ;; Chunk 工具（文件）
  ;; ==================================================================

  ;; void rpng_chunk_print_info(const char *filename)
  (define rpng_chunk_print_info
    (foreign-procedure "rpng_chunk_print_info"
		       (string)
		       void))

  ;; bool rpng_chunk_check_all_valid(const char *filename)
  (define rpng_chunk_check_all_valid
    (foreign-procedure "rpng_chunk_check_all_valid"
		       (string)
		       boolean))

  ;; void rpng_chunk_combine_image_data(const char *filename)
  (define rpng_chunk_combine_image_data
    (foreign-procedure "rpng_chunk_combine_image_data"
		       (string)
		       void))

  ;; void rpng_chunk_split_image_data(const char *filename, int split_size)
  (define rpng_chunk_split_image_data
    (foreign-procedure "rpng_chunk_split_image_data"
		       (string int)
		       void))

  ;; ==================================================================
  ;; Chunk 操作（内存）
  ;; ==================================================================

  ;; int rpng_chunk_count_from_memory(const char *buffer)
  (define rpng_chunk_count_from_memory
    (foreign-procedure "rpng_chunk_count_from_memory"
		       (u8*)
		       int))

  ;; rpng_chunk rpng_chunk_read_from_memory(const char *buffer, const char *chunk_type)
  (define rpng_chunk_read_from_memory
    (let ([proc (foreign-procedure
		 #f "rpng_chunk_read_from_memory"
		 (string string)
		 (& rpng_chunk))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rpng_chunk
			(foreign-alloc (ftype-sizeof rpng_chunk)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; rpng_chunk *rpng_chunk_read_all_from_memory(const char *buffer, int *count)
  (define rpng_chunk_read_all_from_memory
    (foreign-procedure "rpng_chunk_read_all_from_memory"
		       (u8* (* int))
		       (* rpng_chunk)))

  ;; char *rpng_chunk_remove_from_memory(const char *buffer, const char *chunk_type,
  ;;                                     int *output_size)
  (define rpng_chunk_remove_from_memory
    (foreign-procedure "rpng_chunk_remove_from_memory"
		       (u8* string (* int))
		       u8*))

  ;; char *rpng_chunk_remove_ancillary_from_memory(const char *buffer, int *output_size)
  (define rpng_chunk_remove_ancillary_from_memory
    (foreign-procedure "rpng_chunk_remove_ancillary_from_memory"
		       (u8* (* int))
		       u8*))

  ;; char *rpng_chunk_write_from_memory(const char *buffer, rpng_chunk chunk,
  ;;                                    int *output_size)
  (define rpng_chunk_write_from_memory
    (foreign-procedure "rpng_chunk_write_from_memory"
		       (u8* (& rpng_chunk) (* int))
		       u8*))

  ;; char *rpng_chunk_combine_image_data_from_memory(char *buffer, int *output_size)
  (define rpng_chunk_combine_image_data_from_memory
    (foreign-procedure "rpng_chunk_combine_image_data_from_memory"
		       (u8* (* int))
		       u8*))

  ;; char *rpng_chunk_split_image_data_from_memory(char *buffer, int split_size,
  ;;                                               int *output_size)
  (define rpng_chunk_split_image_data_from_memory
    (foreign-procedure "rpng_chunk_split_image_data_from_memory"
		       (u8* int (* int))
		       u8*))
  )
