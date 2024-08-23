shader_type canvas_item;

uniform bool is_applied;

void fragment() {
	if(is_applied) {
		COLOR = vec4(COLOR.r, 0, 0, .5);
		
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
