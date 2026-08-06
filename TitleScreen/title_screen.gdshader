shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 grid(vec2 uv, float columns, float rows) {
	return fract(vec2(uv.x * columns, uv.y * rows));
}

float line(vec2 p1, vec2 p2, float width, vec2 uv) {
	float dist = distance(p1, p2);
	float dist_uv = distance(p1, uv); // distance of p1 to current pixel
	
	//
	return 1.0 - floor(1.0 - (0.001*width) + distance(mix(p1, p2, clamp(dist_uv/dist, 0.0, 1.0)), uv));
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec2 grid = grid(UV, 7.0, 6.0);
	vec3 color = vec3(grid.r, grid.g, 0.2);
	vec2 point1 = vec2(0.45, 0.2);
	vec2 point2 = vec2(0.8, 0.75);
	color += vec3(line(point1, point2, 5.0, UV));
	COLOR = vec4(color,1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
