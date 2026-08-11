shader_type canvas_item;

uniform vec2 aspect = vec2(1.0, 1.777777); // 1152/648 = 1.77
uniform vec2 offset = vec2(0.0);

uniform vec2 margin = vec2(0.2, 0.5);
uniform vec4 bg : source_color = vec4(1.0);

uniform vec2 point_1 = vec2(0.0);
uniform vec2 point_2 = vec2(0.5);

uniform bool is_line = false;

//interesting parameter options:
//---green cube world---
//Offset: -0.61, -0.305
//Margin: 0.041, 0.041
//BG: 89c480

//---dotted world---
//same as before except:
//offset: 0.775, 0.65

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
	
	vec2 grid = grid(UV+(TIME/14.0), 16.0, 9.0);
	vec2 grid_colors = vec2(1.-smoothstep(margin.x, margin.y, grid.r), 1.-smoothstep(margin.x, margin.y, grid.g));//1.-smoothstep(margin.x, margin.y, grid.r+grid.g))
	
	float dist = distance((UV/aspect)+offset, grid_colors);
	
	//vec3 color = vec3(grid.r, grid.g, 0.2);
	vec3 color = bg.rgb;
	color = vec3(1.-dist);
	//color = any(greaterThan(grid_colors.rgb, vec3(0.0))) ? vec3(1.0) :vec3(0.0);
	color *= bg.rgb;
	//vec2 point1 = vec2(0.45, 0.2);
	//vec2 point2 = vec2(0.8, 0.75);
	color += vec3(line(point_1, point_2, 5.0, UV/aspect));
	COLOR = vec4(color, max(color.r,color.g));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
