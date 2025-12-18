#version 330

in vec2 fragTexCoord;
out vec4 finalColor;

uniform sampler2D texture0; // 当前帧（清醒状态）
uniform sampler2D texture1; // 前一帧（睡眠状态）
uniform float progress;     // 过渡进度 (0.0 到 1.0)

void main() {
    // 1. 根据进度计算动态模糊强度（非线性的自然过渡）
    float dynamicBlur = 2.0 * (1.0 - progress * progress);
    
    // 2. 简单的高斯模糊采样
    vec4 sleepColor = vec4(0.0);
    vec4 awakeColor = vec4(0.0);
    float total = 0.0;
    
    // 对两个纹理应用相同的模糊采样
    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 offset = vec2(x, y) * 0.005 * dynamicBlur;
            float weight = 1.0 / (1.0 + abs(x) + abs(y)); // 简单权重
            
            sleepColor += texture(texture1, fragTexCoord + offset) * weight;
            awakeColor += texture(texture0, fragTexCoord + offset) * weight;
            total += weight;
        }
    }
    
    sleepColor /= total;
    awakeColor /= total;
    
    // 3. 非线性混合（开始慢，中间快，结束慢）
    float mixFactor = smoothstep(0.0, 1.0, progress);
    mixFactor = mixFactor * mixFactor * (3.0 - 2.0 * mixFactor); // 平滑曲线
    
    // 4. 混合两种状态
    vec4 mixedColor = mix(sleepColor, awakeColor, mixFactor);
    
    // 5. 亮度变化（从暗到亮）
    float brightness = 0.3 + 0.7 * progress;
    mixedColor.rgb *= brightness;
    
    finalColor = mixedColor;
}