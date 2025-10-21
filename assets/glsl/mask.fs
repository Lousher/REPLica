#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform float progress;  

out vec4 finalColor;

void main() {
    vec4 originColor = texture(texture0, fragTexCoord);
    vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
    float maxBottomMask = progress * 0.15;
    float maxTopMask = 1.0 - maxBottomMask;
    
    if (fragTexCoord.y < maxTopMask && fragTexCoord.y > maxBottomMask) {
       finalColor = originColor;
} else {
       finalColor = black;
}
}