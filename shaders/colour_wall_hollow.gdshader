shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.168, 0.12, 0, 1.0);

uniform float current_alpha = 1.0;

void fragment() {
	COLOR = vec4(color.rgb, current_alpha);
}