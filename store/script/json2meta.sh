#!/bin/bash

# 检查是否提供了足够的参数
if [ "$#" -ne 2 ]; then
    echo "使用方法: $0 <input_csv> <output_ss>"
    exit 1
fi

INPUT=$1
OUTOUT=$2

ATLAS=$(jq -r '[.atlas | .. | scalars] | join(" ")' "$INPUT")
METRICS=$(jq -r '[.metrics | .. | scalars] | join(" ")' "$INPUT")

echo "#[font-meta #[atlas $ATLAS] #[metrics $METRICS]]" > "$OUTOUT"
