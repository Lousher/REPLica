#version 330

in vec3 vertexPos;
in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform vec4 colDiffuse;

uniform float divider= 0;

out vec4 finalColor;

void main() {
  vec4 texelColor0 = texture(texture0, fragTexCoord);
  vec4 texelColor1 = texture(texture1, fragTexCoord);

  float x = fract(fragTexCoord.s);
  float final = smoothstep(divider - 0.1, divider + 0.1, x);

  finalColor = mix(texelColor0, texelColor1, final);
}
