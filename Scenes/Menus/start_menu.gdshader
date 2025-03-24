shader_type canvas_item;

void fragment() {
	vec2 flipped_uv = UV; // Copy UV first

	// Detect bright text color (assuming white text on a transparent background)
	if (texture(TEXTURE, UV).r > 0.9 && texture(TEXTURE, UV).g > 0.9 && texture(TEXTURE, UV).b > 0.9) { 
		flipped_uv.y = 1.0 - flipped_uv.y; // Flip only in the copy
	}

	vec4 color = texture(TEXTURE, flipped_uv); // Sample color using the modified UV
	COLOR = color;
}
