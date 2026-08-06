shader_type canvas_item;

uniform float playing : hint_range(0.0, 1.0, 0.05) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 grid(vec2 uv, float columns, float rows) {
	return fract(vec2(uv.x * columns, uv.y * rows));
}

float circle(vec2 pos, float rad, float feather) {
	return smoothstep(rad, rad+feather, length(pos-vec2(0.5)));
}

vec4 square(vec2 uv, float width) {
	uv = uv *2.0 -1.0;
	
	vec2 abs_uv = abs(uv.xy);
	float square = step(width, max(abs_uv.x, abs_uv.y));
	return vec4(vec3(square), 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
	float centerCircle = (distance(vec2(0.5), UV));
	
	//float centerCircle = circle(UV, 0.2, 0.005);
	float smoothCircle = smoothstep(0.0, 0.5*(playing*7.0), centerCircle);
	
	vec3 color = vec3(0);
	//color += smoothCircle;
	COLOR = square(UV, centerCircle*1.0);
	
	//COLOR = vec4(color, 1.0 - smoothCircle);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
