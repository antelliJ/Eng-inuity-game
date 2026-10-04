shader_type canvas_item;

uniform float speed: hint_range(-10.0, 10.0) = 2.0;
uniform bool vertical = false;


void fragment() {
	vec2 shifted_uv = UV;
	if (vertical) {
		shifted_uv.y += TIME * speed;
	} else {
		shifted_uv.x += TIME * speed;
	}
	
	COLOR = texture(TEXTURE, shifted_uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
