shader_type canvas_item;

uniform bool has_glasses = true;

// Skin
uniform vec4 initial_skin_color : source_color;
uniform vec4 skin_color : source_color;

uniform vec4 initial_skin_shadow : source_color;
uniform vec4 skin_shadow : source_color;

// Ear
uniform vec4 initial_ear_color : source_color;
uniform vec4 ear_color : source_color;

// Glasses
uniform vec4 initial_glasses_frame : source_color;
uniform vec4 glasses_frame : source_color;

uniform vec4 initial_glasses_color : source_color;
uniform vec4 glasses_color : source_color;

uniform vec4 initial_glasses_light : source_color;
uniform vec4 glasses_light : source_color;

// Hair
uniform vec4 initial_hair_color : source_color;
uniform vec4 hair_color : source_color;

uniform vec4 initial_hair_shadow : source_color;
uniform vec4 hair_shadow : source_color;

// Coat
uniform vec4 initial_coat_color : source_color;
uniform vec4 coat_color : source_color;

uniform vec4 initial_coat_shadow : source_color;
uniform vec4 coat_shadow : source_color;

uniform vec4 initial_coat_shadow2 : source_color;
uniform vec4 coat_shadow2 : source_color;

// Pocket
uniform vec4 initial_pocket_color : source_color;
uniform vec4 pocket_color : source_color;

uniform vec4 initial_pocket_color2 : source_color;
uniform vec4 pocket_color2 : source_color;

// Pants
uniform vec4 initial_pants_light : source_color;
uniform vec4 pants_light : source_color;

uniform vec4 initial_pants_shadow : source_color;
uniform vec4 pants_shadow : source_color;

// T-shirt
uniform vec4 initial_tshirt_color : source_color;
uniform vec4 tshirt_color : source_color;

uniform vec4 initial_tshirt_shadow : source_color;
uniform vec4 tshirt_shadow : source_color;

// Shoes
uniform vec4 initial_shoes_light : source_color;
uniform vec4 shoes_light : source_color;

uniform vec4 initial_shoes_color : source_color;
uniform vec4 shoes_color : source_color;

uniform vec4 initial_shoes_shadow : source_color;
uniform vec4 shoes_shadow : source_color;

uniform float threshold = 0.01;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);

	bool replace_glasses_hide = !has_glasses && (
		distance(tex_color.rgb, initial_glasses_frame.rgb) < threshold ||
		distance(tex_color.rgb, initial_glasses_color.rgb) < threshold ||
		distance(tex_color.rgb, initial_glasses_light.rgb) < threshold
	);

	bool replace_skin = distance(tex_color.rgb, initial_skin_color.rgb) < threshold;
	bool replace_shadow = distance(tex_color.rgb, initial_skin_shadow.rgb) < threshold;
	bool replace_ear = distance(tex_color.rgb, initial_ear_color.rgb) < threshold;

	bool replace_hair = distance(tex_color.rgb, initial_hair_color.rgb) < threshold;
	bool replace_hair_shadow = distance(tex_color.rgb, initial_hair_shadow.rgb) < threshold;

	bool replace_coat = distance(tex_color.rgb, initial_coat_color.rgb) < threshold;
	bool replace_coat_shadow = distance(tex_color.rgb, initial_coat_shadow.rgb) < threshold;
	bool replace_coat_shadow2 = distance(tex_color.rgb, initial_coat_shadow2.rgb) < threshold;

	bool replace_pocket = distance(tex_color.rgb, initial_pocket_color.rgb) < threshold;
	bool replace_pocket2 = distance(tex_color.rgb, initial_pocket_color2.rgb) < threshold;

	bool replace_pants_light = distance(tex_color.rgb, initial_pants_light.rgb) < threshold;
	bool replace_pants_shadow = distance(tex_color.rgb, initial_pants_shadow.rgb) < threshold;

	bool replace_tshirt = distance(tex_color.rgb, initial_tshirt_color.rgb) < threshold;
	bool replace_tshirt_shadow = distance(tex_color.rgb, initial_tshirt_shadow.rgb) < threshold;

	bool replace_shoes_light = distance(tex_color.rgb, initial_shoes_light.rgb) < threshold;
	bool replace_shoes = distance(tex_color.rgb, initial_shoes_color.rgb) < threshold;
	bool replace_shoes_shadow = distance(tex_color.rgb, initial_shoes_shadow.rgb) < threshold;

	bool replace_glasses_frame = distance(tex_color.rgb, initial_glasses_frame.rgb) < threshold;
	bool replace_glasses_color = distance(tex_color.rgb, initial_glasses_color.rgb) < threshold;
	bool replace_glasses_light = distance(tex_color.rgb, initial_glasses_light.rgb) < threshold;

	if (replace_glasses_hide || replace_skin) {
		COLOR = vec4(skin_color.rgb, tex_color.a);
	} else if (replace_shadow) {
		COLOR = vec4(skin_shadow.rgb, tex_color.a);
	} else if (replace_ear) {
		COLOR = vec4(ear_color.rgb, tex_color.a);
	} else if (replace_hair) {
		COLOR = vec4(hair_color.rgb, tex_color.a);
	} else if (replace_hair_shadow) {
		COLOR = vec4(hair_shadow.rgb, tex_color.a);
	} else if (replace_coat) {
		COLOR = vec4(coat_color.rgb, tex_color.a);
	} else if (replace_coat_shadow) {
		COLOR = vec4(coat_shadow.rgb, tex_color.a);
	} else if (replace_coat_shadow2) {
		COLOR = vec4(coat_shadow2.rgb, tex_color.a);
	} else if (replace_pocket) {
		COLOR = vec4(pocket_color.rgb, tex_color.a);
	} else if (replace_pocket2) {
		COLOR = vec4(pocket_color2.rgb, tex_color.a);
	} else if (replace_pants_light) {
		COLOR = vec4(pants_light.rgb, tex_color.a);
	} else if (replace_pants_shadow) {
		COLOR = vec4(pants_shadow.rgb, tex_color.a);
	} else if (replace_tshirt) {
		COLOR = vec4(tshirt_color.rgb, tex_color.a);
	} else if (replace_tshirt_shadow) {
		COLOR = vec4(tshirt_shadow.rgb, tex_color.a);
	} else if (replace_shoes_light) {
		COLOR = vec4(shoes_light.rgb, tex_color.a);
	} else if (replace_shoes) {
		COLOR = vec4(shoes_color.rgb, tex_color.a);
	} else if (replace_shoes_shadow) {
		COLOR = vec4(shoes_shadow.rgb, tex_color.a);
	} else if (replace_glasses_frame) {
		COLOR = vec4(glasses_frame.rgb, tex_color.a);
	} else if (replace_glasses_color) {
		COLOR = vec4(glasses_color.rgb, tex_color.a);
	} else if (replace_glasses_light) {
		COLOR = vec4(glasses_light.rgb, tex_color.a);
	} else {
		COLOR = tex_color;
	}
}
