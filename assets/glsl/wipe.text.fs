#version 330

in vec2 fragTexCoord;
in vec4 fragColor;
uniform sampler2D texture0;
uniform vec4 colDiffuse;

// 【唯一需要的参数】: 当前擦除线的位置 (屏幕绝对坐标 X)
uniform float limit;

// 将羽化值写死为常量 (30像素)，如果想改直接改这里
const float feather = 30.0;

out vec4 finalColor;

void main()
{
    vec4 texel = texture(texture0, fragTexCoord);
    vec4 baseColor = texel * colDiffuse * fragColor;

    // 计算透明度遮罩: 左边显示，右边隐藏
    // 1.0 - smoothstep(...) 实现了从 1.0 到 0.0 的平滑过渡
    float alphaMask = 1.0 - smoothstep(limit, limit + feather, gl_FragCoord.x);

    baseColor.a *= alphaMask;
    finalColor = baseColor;
}