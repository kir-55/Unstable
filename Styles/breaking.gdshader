shader_type canvas_item;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 438.5453);
}

uniform float sensitivity : hint_range(0.0, 1.0) = .5;
uniform vec4 cracks_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	// Get size of texture in pixels
	float size_x = float(textureSize(TEXTURE, 0).x);
	float size_y = float(textureSize(TEXTURE, 0).y);
	// 
	vec4 pixelColor = texture(TEXTURE, UV);
	// Create a new "UV" which remaps every UV value to a snapped pixel value
	vec2 UVr = vec2(floor(UV.x*size_x)/size_x, floor(UV.y*size_y)/size_y);
	// Determine whether pixel should be visible or not
	float visible = step((1.0 - sensitivity) / 2.0, random(UVr));
	
	vec4 finalCrackColor = mix(pixelColor, cracks_color, 1.0 - visible);
	// Draw the pixel, or not depending on if it is visible or not
	COLOR = vec4(finalCrackColor.rgb, finalCrackColor.a * pixelColor.a);
}