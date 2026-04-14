#version 330

// 由 Vertex Shader 传来的顶点属性
in vec2 fragTexCoord;
in vec4 fragColor;

// 基础 Uniform 变量
uniform sampler2D texture0;
uniform vec4 colDiffuse;

out vec4 finalColor;

void main()
{
    // 【关键点 1】采样 .r 通道
    // 因为你的图集是灰度图，SDF 距离数据全部映射在红色通道
    float dist = texture(texture0, fragTexCoord).a;

    // 【关键点 2】自适应抗锯齿
    // fwidth(dist) 等同于 abs(dFdx(dist)) + abs(dFdy(dist))
    // 它能计算出当前像素与邻近像素之间的变化率
    float width = fwidth(dist);
    
    // 【关键点 3】阈值裁剪 (0.5)
    // 0.5 是 SDF 的标准中心线。
    // 我们在 [0.5 - width, 0.5 + width] 之间进行平滑过渡
    float alpha = smoothstep(0.5 - width, 0.5 + width, dist);

    // 最终颜色 = 节点颜色 (fragColor) * 计算出的 Alpha
    finalColor = vec4(fragColor.rgb, fragColor.a * alpha);
}