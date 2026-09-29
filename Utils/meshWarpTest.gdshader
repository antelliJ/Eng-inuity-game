shader_type canvas_item;

uniform float warp_intensity = 0.1;

void fragment() {
    vec2 uv = UV;
    // Symmetrical center warp calculation
    vec2 center_offset = uv - 0.5;
    float len = length(center_offset);
    uv += center_offset * sin(len * 10.0 + TIME) * warp_intensity;
    
    COLOR = texture(TEXTURE, uv);
}
