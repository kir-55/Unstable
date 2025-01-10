shader_type canvas_item;

uniform vec4 background_color: source_color;
uniform float max_distance;

void fragment() {
    //float distance_factor = clamp(distance(vec2(SCREEN_UV.x, SCREEN_UV.y), vec2(0.5, 0.5)) / max_distance, 0.0, 1.0);
    //vec4 fade_color = mix(background_color, texture(TEXTURE, UV), 1.0 - distance_factor);
    COLOR = background_color;
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
