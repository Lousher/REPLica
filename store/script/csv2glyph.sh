#!/bin/bash

# 检查是否提供了足够的参数
if [ "$#" -ne 2 ]; then
    echo "使用方法: $0 <input_csv> <output_ss>"
    exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

# 使用参数变量进行 awk 处理
awk -F, '{
    x = $7
    y = $8
    w = $9 - $7
    h = $10 - $8
    printf "#[glyph %s %s #[plane %s %s %s %s] #[rectangle %f %f %f %f]]\n", 
    $1, $2, $3, $4, $5, $6, x, y, w, h
}' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "转换完成: $INPUT_FILE -> $OUTPUT_FILE"
