#version 330

in vec2 fragTexCoord;
in vec4 fragColor;
out vec4 finalColor;

uniform sampler2D texture0;

float median(float r, float g, float b) {
    return max(min(r, g), min(max(r, g), b));
}

void main() {
    vec3 msd = texture(texture0, fragTexCoord).rgb;
    float sd = median(msd.r, msd.g, msd.b);
    
    // 关键点：根据像素密度定义过渡宽度
    // fwidth(sd) 会自动感知你在屏幕上缩放的大小
    float width = fwidth(sd);
    
    // smoothstep 在 [0.5 - width, 0.5 + width] 范围内平滑过渡
    float alpha = smoothstep(0.5 - width, 0.5 + width, sd);
    
    finalColor = vec4(fragColor.rgb, fragColor.a * alpha);
}
