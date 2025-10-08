#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform sampler2D texture1;

uniform float progress;

out vec4 finalColor;

void main() {
     vec4 color0 = texture(texture0, fragTexCoord);
     vec4 color1 = texture(texture1, fragTexCoord);
     finalColor = mix(color0, color1, progress);
}
