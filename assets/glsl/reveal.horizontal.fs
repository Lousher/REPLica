#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
unfirom float progress;
unfirom vec2 center;
uniform float softness;

out vec4 finalColor;

void main()
{
	float distanceFromCenter = abs(fragTexCoord.y - center.y);
	float threshold = (1.0 - progress) * 0.5;
	float alpha = 1.0 - smoothstep(threshold - softness, threshold + softness, distancefromcenter);
	vec4 texColor = texture(texture0, fragTexCoord);

	finalColor = mix(vec4(0.0, 0.0, 0.0, 1.0), texColor, alpha);
}