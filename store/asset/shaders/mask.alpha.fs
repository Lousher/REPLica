#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform float threshold;    // 0.0 = 完全不透明，1.0 = 完全透明
//uniform float softness;     // 边缘羽化宽度，建议默认 0.05，越大过渡越柔和

out vec4 finalColor;

void main() {
    vec4 texel = texture(texture0, fragTexCoord);
    float mask = texture(texture1, fragTexCoord).r;

    float t = clamp(threshold, 0.0, 1.0);
    float soft = max(0.05, 0.0001);          // 防止传 0 时 edge0==edge1，smoothstep 行为未定义

    // 窗口整体往负方向多让出 soft 这么宽，保证 t=0 时窗口完全落在噪点图数值范围之外
    float edge0 = mix(-soft, 1.0, t);
    float edge1 = edge0 + soft;

    float alpha = smoothstep(edge0, edge1, mask);

    finalColor = vec4(texel.rgb, texel.a * alpha);
}