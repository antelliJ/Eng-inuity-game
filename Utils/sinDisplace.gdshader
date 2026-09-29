shader_type canvas_item;

//https://godotshaders.com/shader/sine-morphing/

// --- Uniforms --- //
uniform vec2 amplitutde = vec2(1.0, 0.0);
uniform vec2 speed = vec2(1.0, 0.0);

uniform float state : hint_range(0, 10) = 0;
uniform vec2 offset = vec2(0.0, 0.0);


// --- Functions --- //
void fragment() {
	vec2 pos = mod((UV - amplitutde * sin(state + (vec2(UV.y, UV.x) + offset) * speed)) / TEXTURE_PIXEL_SIZE,
			1.0 / TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE;
	COLOR = texture(TEXTURE, pos);
}