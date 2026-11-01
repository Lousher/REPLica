#version 330

// ---- 来自 raylib 默认 vs 的输入 ----
in vec2 fragTexCoord;
in vec4 fragColor;

// ---- 关键 uniform（与 load-shader 传入的名字一致）----
uniform sampler2D texture0;   // 旧画面
uniform sampler2D texture1;   // 新画面
uniform sampler2D rule;       // 规则图（灰度，r 通道决定切换顺序）

uniform float progress;       // 0.0 → 1.0，由 ticker 每帧推进
uniform float feather;        // 柔边宽度，建议 0.001 ~ 0.05

out vec4 finalColor;

void main()
{
    vec2 uv1 = vec2(fragTexCoord.x, fragTexCoord.y);
    vec2 uv0 = vec2(fragTexCoord.x, 1.0 - fragTexCoord.y);

    vec4  oldColor = texture(texture0, uv1);
    vec4  newColor = texture(texture1, uv0);
    float r        = texture(rule,     uv1).r;

    // progress 推进时，r 小于当前阈值的像素先切换成新画面。
    // smoothstep 在 [progress-feather, progress+feather] 之间做平滑过渡，
    // 避免规则图灰度过渡带上出现硬边。
    float t = smoothstep(progress - feather, progress + feather, r);

    // t=1 → 旧画面，t=0 → 新画面
    finalColor = mix(newColor, oldColor, t) * fragColor;
}