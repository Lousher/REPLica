(library (ffi rres binding)
  (export
   ;; ---- ftype 定义（导出，用于构造按值结构体参数） ----
   rresFileHeader
   rresResourceChunkInfo
   rresResourceChunkData
   rresResourceChunk
   rresResourceMulti
   rresDirEntry
   rresCentralDir
   rresFontGlyphInfo

   ;; ---- 资源加载/卸载 ----
   rresLoadResourceChunk
   rresUnloadResourceChunk
   rresLoadResourceMulti
   rresUnloadResourceMulti
   rresLoadResourceChunkInfo
   rresLoadResourceChunkInfoAll
   rresLoadCentralDirectory
   rresUnloadCentralDirectory

   ;; ---- 工具函数 ----
   rresGetDataType
   rresGetResourceId
   rresComputeCRC32
   rresSetCipherPassword
   rresGetCipherPassword

   ;; ---- 常量：RRES_MAX_FILENAME_SIZE ----
   RRES_MAX_FILENAME_SIZE

   ;; ---- 常量：rresResourceDataType ----
   RRES_DATA_NULL RRES_DATA_RAW RRES_DATA_TEXT RRES_DATA_IMAGE
   RRES_DATA_WAVE RRES_DATA_VERTEX RRES_DATA_FONT_GLYPHS
   RRES_DATA_LINK RRES_DATA_DIRECTORY

   ;; ---- 常量：rresCompressionType ----
   RRES_COMP_NONE RRES_COMP_RLE RRES_COMP_DEFLATE
   RRES_COMP_LZ4 RRES_COMP_LZMA2 RRES_COMP_QOI

   ;; ---- 常量：rresEncryptionType ----
   RRES_CIPHER_NONE RRES_CIPHER_XOR RRES_CIPHER_DES
   RRES_CIPHER_TDES RRES_CIPHER_IDEA RRES_CIPHER_AES
   RRES_CIPHER_AES_GCM RRES_CIPHER_XTEA RRES_CIPHER_BLOWFISH
   RRES_CIPHER_RSA RRES_CIPHER_SALSA20 RRES_CIPHER_CHACHA20
   RRES_CIPHER_XCHACHA20 RRES_CIPHER_XCHACHA20_POLY1305

   ;; ---- 常量：rresErrorType ----
   RRES_SUCCESS RRES_ERROR_FILE_NOT_FOUND
   RRES_ERROR_FILE_FORMAT RRES_ERROR_MEMORY_ALLOC

   ;; ---- 常量：rresTextEncoding ----
   RRES_TEXT_ENCODING_UNDEFINED RRES_TEXT_ENCODING_UTF8
   RRES_TEXT_ENCODING_UTF8_BOM RRES_TEXT_ENCODING_UTF16_LE
   RRES_TEXT_ENCODING_UTF16_BE

   ;; ---- 常量：rresCodeLang ----
   RRES_CODE_LANG_UNDEFINED RRES_CODE_LANG_C RRES_CODE_LANG_CPP
   RRES_CODE_LANG_CS RRES_CODE_LANG_LUA RRES_CODE_LANG_JS
   RRES_CODE_LANG_PYTHON RRES_CODE_LANG_RUST RRES_CODE_LANG_ZIG
   RRES_CODE_LANG_ODIN RRES_CODE_LANG_JAI RRES_CODE_LANG_GDSCRIPT
   RRES_CODE_LANG_GLSL

   ;; ---- 常量：rresPixelFormat ----
   RRES_PIXELFORMAT_UNDEFINED
   RRES_PIXELFORMAT_UNCOMP_GRAYSCALE
   RRES_PIXELFORMAT_UNCOMP_GRAY_ALPHA
   RRES_PIXELFORMAT_UNCOMP_R5G6B5
   RRES_PIXELFORMAT_UNCOMP_R8G8B8
   RRES_PIXELFORMAT_UNCOMP_R5G5B5A1
   RRES_PIXELFORMAT_UNCOMP_R4G4B4A4
   RRES_PIXELFORMAT_UNCOMP_R8G8B8A8
   RRES_PIXELFORMAT_UNCOMP_R32
   RRES_PIXELFORMAT_UNCOMP_R32G32B32
   RRES_PIXELFORMAT_UNCOMP_R32G32B32A32
   RRES_PIXELFORMAT_COMP_DXT1_RGB
   RRES_PIXELFORMAT_COMP_DXT1_RGBA
   RRES_PIXELFORMAT_COMP_DXT3_RGBA
   RRES_PIXELFORMAT_COMP_DXT5_RGBA
   RRES_PIXELFORMAT_COMP_ETC1_RGB
   RRES_PIXELFORMAT_COMP_ETC2_RGB
   RRES_PIXELFORMAT_COMP_ETC2_EAC_RGBA
   RRES_PIXELFORMAT_COMP_PVRT_RGB
   RRES_PIXELFORMAT_COMP_PVRT_RGBA
   RRES_PIXELFORMAT_COMP_ASTC_4x4_RGBA
   RRES_PIXELFORMAT_COMP_ASTC_8x8_RGBA

   ;; ---- 常量：rresVertexAttribute ----
   RRES_VERTEX_ATTRIBUTE_POSITION
   RRES_VERTEX_ATTRIBUTE_TEXCOORD1
   RRES_VERTEX_ATTRIBUTE_TEXCOORD2
   RRES_VERTEX_ATTRIBUTE_TEXCOORD3
   RRES_VERTEX_ATTRIBUTE_TEXCOORD4
   RRES_VERTEX_ATTRIBUTE_NORMAL
   RRES_VERTEX_ATTRIBUTE_TANGENT
   RRES_VERTEX_ATTRIBUTE_COLOR
   RRES_VERTEX_ATTRIBUTE_INDEX

   ;; ---- 常量：rresVertexFormat ----
   RRES_VERTEX_FORMAT_UBYTE RRES_VERTEX_FORMAT_BYTE
   RRES_VERTEX_FORMAT_USHORT RRES_VERTEX_FORMAT_SHORT
   RRES_VERTEX_FORMAT_UINT RRES_VERTEX_FORMAT_INT
   RRES_VERTEX_FORMAT_HFLOAT RRES_VERTEX_FORMAT_FLOAT

   ;; ---- 常量：rresFontStyle ----
   RRES_FONT_STYLE_UNDEFINED RRES_FONT_STYLE_REGULAR
   RRES_FONT_STYLE_BOLD RRES_FONT_STYLE_ITALIC)

  (import (chezscheme))

  ;; ==================================================================
  ;; ftype 定义（按依赖顺序）
  ;; ==================================================================

  (define-ftype rresFileHeader
    (struct
      [id        (array 4 unsigned-8)]
      [version   unsigned-16]
      [chunkCount unsigned-16]
      [cdOffset  unsigned-32]
      [reserved  unsigned-32]))

  (define-ftype rresResourceChunkInfo
    (struct
      [type        (array 4 unsigned-8)]
      [id          unsigned-32]
      [compType    unsigned-8]
      [cipherType  unsigned-8]
      [flags       unsigned-16]
      [packedSize  unsigned-32]
      [baseSize    unsigned-32]
      [nextOffset  unsigned-32]
      [reserved    unsigned-32]
      [crc32       unsigned-32]))

  (define-ftype rresResourceChunkData
    (struct
      [propCount unsigned-32]
      [props     (* unsigned-32)]
      [raw       void*]))

  (define-ftype rresResourceChunk
    (struct
      [info rresResourceChunkInfo]
      [data rresResourceChunkData]))

  (define-ftype rresResourceMulti
    (struct
      [count  unsigned-32]
      [chunks (* rresResourceChunk)]))

  (define-ftype rresDirEntry
    (struct
      [id           unsigned-32]
      [offset       unsigned-32]
      [reserved     unsigned-32]
      [fileNameSize unsigned-32]
      [fileName     (array 1024 char)]))

  (define-ftype rresCentralDir
    (struct
      [count   unsigned-32]
      [entries (* rresDirEntry)]))
  
  (define-ftype rresFontGlyphInfo
    (struct
      [x        int]
      [y        int]
      [width    int]
      [height   int]
      [value    int]
      [offsetX  int]
      [offsetY  int]
      [advanceX int]))

  ;; ==================================================================
  ;; 常量
  ;; ==================================================================

  (define RRES_MAX_FILENAME_SIZE 1024)

  ;; rresResourceDataType
  (define RRES_DATA_NULL         0)
  (define RRES_DATA_RAW          1)
  (define RRES_DATA_TEXT         2)
  (define RRES_DATA_IMAGE        3)
  (define RRES_DATA_WAVE         4)
  (define RRES_DATA_VERTEX       5)
  (define RRES_DATA_FONT_GLYPHS  6)
  (define RRES_DATA_LINK         99)
  (define RRES_DATA_DIRECTORY    100)

  ;; rresCompressionType
  (define RRES_COMP_NONE     0)
  (define RRES_COMP_RLE      1)
  (define RRES_COMP_DEFLATE  10)
  (define RRES_COMP_LZ4      20)
  (define RRES_COMP_LZMA2    30)
  (define RRES_COMP_QOI      40)

  ;; rresEncryptionType
  (define RRES_CIPHER_NONE               0)
  (define RRES_CIPHER_XOR                1)
  (define RRES_CIPHER_DES                10)
  (define RRES_CIPHER_TDES               11)
  (define RRES_CIPHER_IDEA               20)
  (define RRES_CIPHER_AES                30)
  (define RRES_CIPHER_AES_GCM            31)
  (define RRES_CIPHER_XTEA               40)
  (define RRES_CIPHER_BLOWFISH           50)
  (define RRES_CIPHER_RSA                60)
  (define RRES_CIPHER_SALSA20            70)
  (define RRES_CIPHER_CHACHA20           71)
  (define RRES_CIPHER_XCHACHA20          72)
  (define RRES_CIPHER_XCHACHA20_POLY1305 73)

  ;; rresErrorType
  (define RRES_SUCCESS                0)
  (define RRES_ERROR_FILE_NOT_FOUND   1)
  (define RRES_ERROR_FILE_FORMAT      2)
  (define RRES_ERROR_MEMORY_ALLOC     3)

  ;; rresTextEncoding
  (define RRES_TEXT_ENCODING_UNDEFINED 0)
  (define RRES_TEXT_ENCODING_UTF8      1)
  (define RRES_TEXT_ENCODING_UTF8_BOM  2)
  (define RRES_TEXT_ENCODING_UTF16_LE  10)
  (define RRES_TEXT_ENCODING_UTF16_BE  11)

  ;; rresCodeLang
  (define RRES_CODE_LANG_UNDEFINED 0)
  (define RRES_CODE_LANG_C         1)
  (define RRES_CODE_LANG_CPP       2)
  (define RRES_CODE_LANG_CS        3)
  (define RRES_CODE_LANG_LUA       4)
  (define RRES_CODE_LANG_JS        5)
  (define RRES_CODE_LANG_PYTHON    6)
  (define RRES_CODE_LANG_RUST      7)
  (define RRES_CODE_LANG_ZIG       8)
  (define RRES_CODE_LANG_ODIN      9)
  (define RRES_CODE_LANG_JAI       10)
  (define RRES_CODE_LANG_GDSCRIPT  11)
  (define RRES_CODE_LANG_GLSL      12)

  ;; rresPixelFormat
  (define RRES_PIXELFORMAT_UNDEFINED             0)
  (define RRES_PIXELFORMAT_UNCOMP_GRAYSCALE      1)
  (define RRES_PIXELFORMAT_UNCOMP_GRAY_ALPHA     2)
  (define RRES_PIXELFORMAT_UNCOMP_R5G6B5         3)
  (define RRES_PIXELFORMAT_UNCOMP_R8G8B8         4)
  (define RRES_PIXELFORMAT_UNCOMP_R5G5B5A1       5)
  (define RRES_PIXELFORMAT_UNCOMP_R4G4B4A4       6)
  (define RRES_PIXELFORMAT_UNCOMP_R8G8B8A8       7)
  (define RRES_PIXELFORMAT_UNCOMP_R32            8)
  (define RRES_PIXELFORMAT_UNCOMP_R32G32B32      9)
  (define RRES_PIXELFORMAT_UNCOMP_R32G32B32A32   10)
  (define RRES_PIXELFORMAT_COMP_DXT1_RGB         11)
  (define RRES_PIXELFORMAT_COMP_DXT1_RGBA        12)
  (define RRES_PIXELFORMAT_COMP_DXT3_RGBA        13)
  (define RRES_PIXELFORMAT_COMP_DXT5_RGBA        14)
  (define RRES_PIXELFORMAT_COMP_ETC1_RGB         15)
  (define RRES_PIXELFORMAT_COMP_ETC2_RGB         16)
  (define RRES_PIXELFORMAT_COMP_ETC2_EAC_RGBA    17)
  (define RRES_PIXELFORMAT_COMP_PVRT_RGB         18)
  (define RRES_PIXELFORMAT_COMP_PVRT_RGBA        19)
  (define RRES_PIXELFORMAT_COMP_ASTC_4x4_RGBA    20)
  (define RRES_PIXELFORMAT_COMP_ASTC_8x8_RGBA    21)

  ;; rresVertexAttribute
  (define RRES_VERTEX_ATTRIBUTE_POSITION  0)
  (define RRES_VERTEX_ATTRIBUTE_TEXCOORD1 10)
  (define RRES_VERTEX_ATTRIBUTE_TEXCOORD2 11)
  (define RRES_VERTEX_ATTRIBUTE_TEXCOORD3 12)
  (define RRES_VERTEX_ATTRIBUTE_TEXCOORD4 13)
  (define RRES_VERTEX_ATTRIBUTE_NORMAL    20)
  (define RRES_VERTEX_ATTRIBUTE_TANGENT   30)
  (define RRES_VERTEX_ATTRIBUTE_COLOR     40)
  (define RRES_VERTEX_ATTRIBUTE_INDEX     100)

  ;; rresVertexFormat
  (define RRES_VERTEX_FORMAT_UBYTE  0)
  (define RRES_VERTEX_FORMAT_BYTE   1)
  (define RRES_VERTEX_FORMAT_USHORT 2)
  (define RRES_VERTEX_FORMAT_SHORT  3)
  (define RRES_VERTEX_FORMAT_UINT   4)
  (define RRES_VERTEX_FORMAT_INT    5)
  (define RRES_VERTEX_FORMAT_HFLOAT 6)
  (define RRES_VERTEX_FORMAT_FLOAT  7)

  ;; rresFontStyle
  (define RRES_FONT_STYLE_UNDEFINED 0)
  (define RRES_FONT_STYLE_REGULAR   1)
  (define RRES_FONT_STYLE_BOLD      2)
  (define RRES_FONT_STYLE_ITALIC    3)

  ;; ==================================================================
  ;; 资源加载/卸载
  ;; ==================================================================

  ;; rresResourceChunk rresLoadResourceChunk(const char *fileName, unsigned int rresId)
  (define rresLoadResourceChunk
    (let ([proc (foreign-procedure
		 #f "rresLoadResourceChunk"
		 (string unsigned-32)
		 (& rresResourceChunk))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rresResourceChunk
			(foreign-alloc (ftype-sizeof rresResourceChunk)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; void rresUnloadResourceChunk(rresResourceChunk chunk)
  (define rresUnloadResourceChunk
    (foreign-procedure "rresUnloadResourceChunk"
		       ((& rresResourceChunk))
		       void))

  ;; rresResourceMulti rresLoadResourceMulti(const char *fileName, unsigned int rresId)
  (define rresLoadResourceMulti
    (let ([proc (foreign-procedure
		 #f "rresLoadResourceMulti"
		 (string unsigned-32)
		 (& rresResourceMulti))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rresResourceMulti
			(foreign-alloc (ftype-sizeof rresResourceMulti)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; void rresUnloadResourceMulti(rresResourceMulti multi)
  (define rresUnloadResourceMulti
    (foreign-procedure "rresUnloadResourceMulti"
		       ((& rresResourceMulti))
		       void))

  ;; rresResourceChunkInfo rresLoadResourceChunkInfo(const char *fileName, unsigned int rresId)
  (define rresLoadResourceChunkInfo
    (let ([proc (foreign-procedure
		 #f "rresLoadResourceChunkInfo"
		 (string unsigned-32)
		 (& rresResourceChunkInfo))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rresResourceChunkInfo
			(foreign-alloc (ftype-sizeof rresResourceChunkInfo)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; rresResourceChunkInfo *rresLoadResourceChunkInfoAll(const char *fileName, unsigned int *chunkCount)
  (define rresLoadResourceChunkInfoAll
    (foreign-procedure "rresLoadResourceChunkInfoAll"
		       (string (* unsigned-32))
		       (* rresResourceChunkInfo)))

  ;; rresCentralDir rresLoadCentralDirectory(const char *fileName)
  (define rresLoadCentralDirectory
    (let ([proc (foreign-procedure
		 #f "rresLoadCentralDirectory"
		 (string)
		 (& rresCentralDir))])
      (lambda xargs
	(let ([ret-res (make-ftype-pointer
			rresCentralDir
			(foreign-alloc (ftype-sizeof rresCentralDir)))])
	  (apply proc ret-res xargs)
	  ret-res))))

  ;; void rresUnloadCentralDirectory(rresCentralDir dir)
  (define rresUnloadCentralDirectory
    (foreign-procedure "rresUnloadCentralDirectory"
		       ((& rresCentralDir))
		       void))

  ;; ==================================================================
  ;; 工具函数
  ;; ==================================================================

  ;; unsigned int rresGetDataType(const unsigned char *fourCC)
  (define rresGetDataType
    (foreign-procedure "rresGetDataType"
		       (u8*)
		       unsigned-32))

  ;; unsigned int rresGetResourceId(rresCentralDir dir, const char *fileName)
  (define rresGetResourceId
    (foreign-procedure "rresGetResourceId"
		       ((& rresCentralDir) string)
		       unsigned-32))

  ;; unsigned int rresComputeCRC32(const unsigned char *data, int len)
  (define rresComputeCRC32
    (foreign-procedure "rresComputeCRC32"
		       (u8* int)
		       unsigned-32))

  ;; void rresSetCipherPassword(const char *pass)
  (define rresSetCipherPassword
    (foreign-procedure "rresSetCipherPassword"
		       (string)
		       void))

  ;; const char *rresGetCipherPassword(void)
  (define rresGetCipherPassword
    (foreign-procedure "rresGetCipherPassword"
		       ()
		       string)))
