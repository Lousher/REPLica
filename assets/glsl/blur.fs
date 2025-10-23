#version 330

// 输入：纹理坐标
in vec2 fragTexCoord;
// 输入纹理
uniform sampler2D texture0;
// 统一变量：控制模糊进度 (0.0清晰 - 1.0模糊)
uniform float progress;

// 最终输出颜色
out vec4 finalColor;

void main()
{
    vec2 uv = fragTexCoord;
    vec4 originalColor = texture(texture0, uv);

    // 1. 根据progress计算模糊强度
    // 当progress为0时，blurRadius为0，效果清晰。
    // 可以根据需要调整系数（如0.05）来控制最大模糊程度。
    float blurRadius = progress * 0.02;

    // 2. 定义基于纹理坐标的采样偏移方向（简化版，可扩展）
    // 这里以一个简单的四方向采样为例，实现基础模糊
    vec2 offset1 = vec2(blurRadius, blurRadius);
    vec2 offset2 = vec2(-blurRadius, blurRadius);
    vec2 offset3 = vec2(blurRadius, -blurRadius);
    vec2 offset4 = vec2(-blurRadius, -blurRadius);

    // 3. 进行采样并混合
    vec4 blurredColor = originalColor; // 中心点采样
    blurredColor += texture(texture0, uv + offset1);
    blurredColor += texture(texture0, uv + offset2);
    blurredColor += texture(texture0, uv + offset3);
    blurredColor += texture(texture0, uv + offset4);
    blurredColor /= 5.0; // 除以采样点数得到平均颜色

    // 4. 根据progress在原始颜色和模糊颜色之间进行混合
    // 当progress为0时，finalColor = originalColor（清晰）
    // 当progress为1时，finalColor = blurredColor（模糊）
    finalColor = mix(originalColor, blurredColor, progress);
}