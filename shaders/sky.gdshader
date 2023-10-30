shader_type canvas_item;

uniform float speed_x : hint_range(-1.0, 1.0) = .015;
uniform float speed_y : hint_range(-1.0, 1.0) = 0;

void fragment() {
	vec2 uv = UV;
	uv.x += speed_x * TIME;
	uv.y += speed_y * TIME;
    vec4 tex = texture(TEXTURE, uv);
    COLOR = tex;
}