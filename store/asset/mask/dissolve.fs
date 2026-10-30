#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform float progress;

out vec4 finalColor;

void main() {
    // 1. 保险机制：极值直接输出，防止任何浮点运算残留
    if (progress <= 0.01) {
        finalColor = texture2D(texture0, fragTexCoord) * fragColor;
        return;
    }
    if (progress >= 0.99) {
        finalColor = vec4(0.0); 
        return;
    }

    // 2. 正常采样并修正 Y 轴
    vec4 baseColor = texture2D(texture0, fragTexCoord) * fragColor;
    vec2 maskTexCoord = vec2(fragTexCoord.x, 1.0 - fragTexCoord.y);
    // 噪点图经常带有 JPG 压缩色彩，强制只取 r 通道作为纯粹的灰度
    float maskValue = texture2D(texture1, maskTexCoord).r;

    // 3. 扩宽死区，应对 JPG 压缩导致的极值不准（022.jpg 的黑可能不是绝对的 0）
    float threshold = progress * 1.2 - 0.1;

    // 4. 【核心修改】放弃 smoothstep，改用 step！
    // step(edge, x)：如果 x < edge 返回 0.0，否则返回 1.0。
    // 这保证了噪点溶解极其锐利，绝不产生会发黑的半透明像素。
    float alpha = step(threshold, maskValue);

    // 5. 【核心修改】取消预乘 RGB，直接输出，交由底层的标准 Alpha 混合去处理
    finalColor = vec4(baseColor.rgb, baseColor.a * alpha);
}