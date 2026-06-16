#version 330

// 输入变量
in vec2 fragTexCoord;
in vec4 fragColor;

// 输出变量
out vec4 finalColor;

// 纹理单元
uniform sampler2D texture0;
// 核心参数：对应你打包时的 -pxrange 参数 (通常是 2.0 或 4.0)
uniform float pxRange; 

// 寻找 RGB 中的中间值
float median(float r, float g, float b) {
    return max(min(r, g), min(max(r, g), b));
}

void main() {
    // 1. 采样 MSDF 纹理
    vec3 msd = texture(texture0, fragTexCoord).rgb;
    float sd = median(msd.r, msd.g, msd.b);

    // 2. 屏幕空间导数计算 (核心抗锯齿)
    // 乘上 pxRange 来标准化距离场，使其在不同缩放尺度下表现一致
    float screenPxDistance = pxRange * (sd - 0.5);
    float opacity = clamp(screenPxDistance + 0.5, 0.0, 1.0);

    // 3. 应用颜色和 Alpha
    finalColor = vec4(fragColor.rgb, fragColor.a * opacity);
}