shader_type canvas_item;

uniform float playing : hint_range(0.0, 1.0, 0.05) = 0.5;
uniform vec2 aspect = vec2(1.0, 1.777777); // 1152/648 = 1.77
uniform vec2 numOfTiles = vec2(16., 9.);
uniform bool reverse = true;
uniform vec2 pixelsPerTile = vec2(16,16);


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
	vec2 posInSquare = UV * numOfTiles;
	vec2 pixelPos = round(posInSquare * pixelsPerTile);
	vec2 frac = fract(pixelPos / pixelsPerTile);
	vec2 direction = abs(frac - 0.5); // get manhattan distance
	float dist = distance(vec2(0.5)/aspect, UV/aspect);
	
	if (direction.x+direction.y + dist >= playing *3.){
		if (!reverse) {
			discard;
		}
	}else if (reverse){
		discard;
	}
}
