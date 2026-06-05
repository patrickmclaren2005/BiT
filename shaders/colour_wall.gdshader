shader_type canvas_item;

uniform vec4 node_colour = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = node_colour;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
