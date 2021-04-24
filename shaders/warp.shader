shader_type canvas_item;

void fragment() {
	float x = SCREEN_UV.x - 0.5;
	float y = SCREEN_UV.y - 0.5;
	y *= (1.0 - cos(x));
	x *= 10.0 * (1.0 - cos(y));
	if (SCREEN_UV.y + y > 1.0 || SCREEN_UV.y + y < 0.0 || SCREEN_UV.x + x > 1.0 || SCREEN_UV.x + x < 0.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(x, y));
	}
	
}