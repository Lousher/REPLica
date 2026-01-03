#version 330

// --------------------------------------------------------
//   Cinematic Look-Up Transition (High Quality)
//   Author: Gemini
//   Description: 模拟头部向上仰望天空，带动态模糊和惯性缓冲
// --------------------------------------------------------

in vec2 fragTexCoord;
in vec4 fragColor;

// 【重要】根据你的要求：
// texture0 = 目标图 (Target/Sky/End) -> progress = 1.0 时显示
// texture1 = 原图 (Source/Ground/Start) -> progress = 0.0 时显示
uniform sampler2D texture0; 
uniform sampler2D texture1;
uniform float progress;

out vec4 finalColor;

// --- 配置参数 (可在此调整效果) ---
const float BLUR_INTENSITY = 0.08;  // 模糊强度 (0.05 - 0.15 最佳)
const int   BLUR_SAMPLES   = 12;    // 模糊采样次数 (高=细腻但耗性能, 低=粗糙, 8-16 最佳)
const float DIM_STRENGTH   = 0.3;   // 中间过程变暗程度 (0.0=不变, 1.0=全黑, 掩盖接缝用)

// 缓动函数：让运动不像机器人一样生硬，而是两头慢中间快
float easeInOutCubic(float t) {
    return t < 0.5 ? 4.0 * t * t * t : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

// 辅助函数：获取源图颜色 (Texture1)
vec4 getFromColor(vec2 uv) {
    return texture(texture1, uv);
}

// 辅助函数：获取目标图颜色 (Texture0)
vec4 getToColor(vec2 uv) {
    return texture(texture0, uv);
}

void main() {
    vec2 uv = fragTexCoord;
    
    // 1. 应用缓动曲线，获取当前的“视觉位置”
    // smoothedProgress 0.0 -> 1.0
    float smoothedProgress = easeInOutCubic(progress);

    // 2. 计算当前的模糊力度
    // 使用抛物线原理：progress 在 0.0 和 1.0 时模糊为 0，在 0.5 时模糊最大
    float currentBlur = sin(smoothedProgress * 3.1415926) * BLUR_INTENSITY;

    // 3. 计算当前的变暗系数 (用来掩盖接缝)
    float dimming = 1.0 - (sin(smoothedProgress * 3.1415926) * DIM_STRENGTH);

    vec4 accColor = vec4(0.0);
    float totalWeight = 0.0;

    // 4. 循环采样实现动态模糊 (Motion Blur)
    // 我们不是只采一个点，而是沿着垂直方向采一串点取平均值
    for (int i = 0; i < BLUR_SAMPLES; i++) {
        // 计算偏移量：从 -blur 到 +blur 之间分布
        float offset = (float(i) / float(BLUR_SAMPLES - 1) - 0.5) * currentBlur;
        
        // 核心逻辑：模拟抬头
        // 抬头 = 视线向上移 = 画面向下移
        // 逻辑坐标：Ground(Tex1) 在 [0,1]，Sky(Tex0) 在 [1,2]
        // 采样坐标 sampleY = uv.y + 进度位移 + 模糊偏移
        float sampleY = uv.y + smoothedProgress + offset;

        vec4 sampleColor;

        // 判断我们要采哪张图
        if (sampleY < 1.0) {
            // 还没移出原图范围 -> 显示原图 (Texture1)
            // 加上边界保护 clamp，防止边缘重复像素溢出
            sampleColor = getFromColor(vec2(uv.x, clamp(sampleY, 0.0, 0.999)));
        } else {
            // 移出了原图 -> 显示目标图 (Texture0)
            // 减去 1.0，把坐标映射回 [0,1]
            // 同样加上 clamp
            sampleColor = getToColor(vec2(uv.x, clamp(sampleY - 1.0, 0.0, 1.0)));
        }

        // 简单的权重分配 (这里用平均权重)
        accColor += sampleColor;
        totalWeight += 1.0;
    }

    // 5. 混合最终颜色
    vec4 finalResult = accColor / totalWeight;

    // 6. 应用变暗效果
    finalColor = vec4(finalResult.rgb * dimming, finalResult.a);
}