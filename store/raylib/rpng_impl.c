// libs.c —— 确保所有内部依赖的实现都被激活

// 1. 先激活 rpng 内部的 DEFLATE 压缩/解压实现
#define SDEFL_IMPLEMENTATION
#include "sdefl.h"

#define SINFL_IMPLEMENTATION
#include "sinfl.h"

// 2. 再激活 rpng 本身的实现
#define RPNG_IMPLEMENTATION
#include "rpng.h"

// 3. 其他库（如果是在同一个 libs.c 里）
// #define RINI_IMPLEMENTATION
// #include "rini.h"
// ...
