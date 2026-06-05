shader_type canvas_item;

uniform vec4 nodeColour = vec4(1.0, 1.0, 1.0, 1.0);
uniform float nodeModulate = 1.0;
void vertex() {
	//
}

void fragment() {
	vec2 center = vec2(0.5,0.5);
	float distanceFromCenter = distance(UV, center);
	float radius = 0.5;
	if (distanceFromCenter > radius)
	{
		discard;
	}
	COLOR = vec4(nodeColour.xyz, nodeModulate);
}
void light() {
  	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, LIGHT_COLOR.a);
}
