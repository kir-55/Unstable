shader_type canvas_item;

uniform float saturation : hint_range(0.0, 1.0) = 0.5;
uniform float blueness : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	// Convert to grayscale based on luminance
	vec3 grayscale = vec3(dot(tex_color.rgb, vec3(0.299, 0.587, 0.114)));

	// Mix original color with grayscale (desaturation)
	vec3 desaturated = mix(grayscale, tex_color.rgb, saturation);

	// Mix desaturated color with light blue to simulate background tint
	vec3 blue_tint = mix(desaturated, vec3(0.5, 0.6, 1.0), blueness);

	COLOR.rgb = blue_tint;
	COLOR.a = tex_color.a;
}
