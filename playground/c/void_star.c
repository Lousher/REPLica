#include <stdio.h>

// 简单的演示函数，接受 void* 参数
void demo_function(void* ptr) {
    if (ptr == NULL) {
        printf("Received NULL pointer\n");
    } else {
        printf("Pointer address: %p\n", ptr);
        
        // 假设指针指向整数
        int* int_ptr = (int*)ptr;
        printf("Value at pointer: %d\n", *int_ptr);
    }
}
