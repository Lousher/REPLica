// u8_test.c - 测试 unsigned char* 的简单 C 函数
// 编译: gcc -shared -fPIC -o libu8_test.so u8_test.c

// 1. 计算字节数组的总和
int sum_bytes(unsigned char *data, int length) {
    int sum = 0;
    for (int i = 0; i < length; i++) {
        sum += data[i];
    }
    return sum;
}

// 2. 每个字节加 1
void add_one(unsigned char *data, int length) {
    for (int i = 0; i < length; i++) {
        data[i] = data[i] + 1;
    }
}

// 3. 翻转字节数组
void reverse_bytes(unsigned char *data, int length) {
    for (int i = 0; i < length / 2; i++) {
        unsigned char temp = data[i];
        data[i] = data[length - 1 - i];
        data[length - 1 - i] = temp;
    }
}

// 4. 用指定值填充数组
void fill_bytes(unsigned char *data, int length, unsigned char value) {
    for (int i = 0; i < length; i++) {
        data[i] = value;
    }
}
