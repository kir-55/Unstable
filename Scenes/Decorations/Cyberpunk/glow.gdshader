shader_type canvas_item;

uniform float glow_size = 4.0;
uniform float glow_strength = 1.0;
uniform vec4 glow_color : source_color;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 final_color = tex_color;

    float alpha = tex_color.a;
    for (float x = -glow_size; x <= glow_size; x++) {
        for (float y = -glow_size; y <= glow_size; y++) {
            vec2 offset = vec2(x, y) / vec2(textureSize(TEXTURE, 0));
            alpha = max(alpha, texture(TEXTURE, UV + offset).a);
        }
    }

    final_color += glow_color * alpha * glow_strength;
    COLOR = final_color;
}