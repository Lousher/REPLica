#include <stdio.h>
#include <stdarg.h>

// 第一个参数 count 表示后面跟了多少个整数
int sum(int count, ...) {
    va_list args;
    int total = 0;

    // 1. 初始化 va_list，指定从哪个参数之后开始变参
    va_start(args, count);

    // 2. 循环遍历提取参数
    for (int i = 0; i < count; i++) {
        // va_arg 指定参数类型为 int
        total += va_arg(args, int);
    }

    // 3. 清理 va_list
    va_end(args);

    return total;
}
