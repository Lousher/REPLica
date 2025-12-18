#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

out vec4 finalColor;

uniform sampler2D texture0;
uniform vec4 color;
uniform float width;

void main()
{
	vec4 texel = texture(texture0, fragTexCoord);

	if (texel.a > 0.5) {
	   finalColor = texel * fragColor;
	} else {
	  vec2 texSize = vec2(textureSize(texture0, 0));
	  vec2 texStep = width / texSize;
	

	float alpha = 0.0;

	alpha += texture(texture0, fragTexCoord + vec2(texStep.x, 0.0)).a;
        alpha += texture(texture0, fragTexCoord + vec2(-texStep.x, 0.0)).a;
        alpha += texture(texture0, fragTexCoord + vec2(0.0, texStep.y)).a;
        alpha += texture(texture0, fragTexCoord + vec2(0.0,-texStep.y)).a;

	if (alpha > 0.0) {
            finalColor = color;
        } else {
            finalColor = vec4(0.0);
        }
	}	
}