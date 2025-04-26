shader_type canvas_item;
render_mode unshaded;

uniform float circle_size : hint_range(0.0, 3) = 0.5;
uniform float feather_inner : hint_range(0.0, 3) = 0.02;
uniform float feather_outer : hint_range(0.0, 3) = 0.05;

uniform vec2 circle_position = vec2(0.5, 0.5);
uniform float screen_width = 1920.0;
uniform float screen_height = 1080.0;

uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // << added customizable color

void fragment() {
	float aspect = screen_width / screen_height;

	vec2 adjusted_uv = vec2((UV.x - circle_position.x) * aspect, UV.y - circle_position.y);
	float dist = length(adjusted_uv);

	float edge_start = circle_size - feather_inner;
	float edge_end = circle_size + feather_outer;

	float alpha = smoothstep(edge_start, edge_end, dist);

	// Set COLOR using the selected color and calculated alpha
	COLOR = color;
	COLOR.a *= alpha;
}
