#version 330

// 输入：从顶点着色器传来的纹理坐标
in vec2 fragTexCoord;
// 输入纹理（即渲染到RenderTexture2D上的场景）
uniform sampler2D texture0;
// 统一变量：控制效果进度 (0.0: 刚醒来, 1.0: 完全清醒)
uniform float progress;

// 最终输出颜色
out vec4 finalColor;

void main()
{
    vec4 originalColor = texture(texture0, fragTexCoord);

    // 1. 模糊效果 (随着progress增加而减弱)
    float blurStrength = (1.0 - progress) * 0.02; // 最大模糊强度可调
    vec4 blurredColor = originalColor;
    // 一个简单的4方向采样模糊，追求效果可替换为更复杂的高斯模糊
    blurredColor += texture(texture0, fragTexCoord + vec2(blurStrength, blurStrength));
    blurredColor += texture(texture0, fragTexCoord + vec2(-blurStrength, blurStrength));
    blurredColor += texture(texture0, fragTexCoord + vec2(blurStrength, -blurStrength));
    blurredColor += texture(texture0, fragTexCoord + vec2(-blurStrength, -blurStrength));
    blurredColor /= 5.0;

    // 2. 亮度变化 (刚醒来时较暗，逐渐变亮)
    float wakeupLightFactor = 0.5 + 0.5 * progress; // 从0.5线性增强到1.0
    vec4 darkenedColor = blurredColor * wakeupLightFactor;

    // 3. 色彩饱和度 (可选：刚醒来时饱和度较低，逐渐恢复)
    // 计算亮度
    float luminance = dot(darkenedColor.rgb, vec3(0.299, 0.587, 0.114));
    // 在低饱和度(0.0)和原始饱和度(1.0)之间根据progress插值
    float saturationFactor = progress;
    vec4 desaturatedColor = mix(vec4(luminance, luminance, luminance, darkenedColor.a), darkenedColor, saturationFactor);

    // 根据progress值，在“处理后的颜色”和“原始清晰颜色”之间平滑过渡
    // progress为0时，显示desaturatedColor（模糊、暗、低饱和）
    // progress为1时，显示originalColor（完全清晰）
    finalColor = mix(desaturatedColor, originalColor, progress * progress); // 使用progress的平方可以使清晰化过程后期更快，按需调整
}