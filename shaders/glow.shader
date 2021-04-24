shader_type canvas_item;

void fragment() {
	float sd = 10.0;
	float pi = 3.141592653;
	float e = 2.71828;
	float left = 1.0 / (2.0 * pi * pow(sd, 2));
	vec4 sum = vec4(0.0);
	for (float x = -8.0; x < 8.0; x += 4.0) {
		for (float y = -8.0; y < 8.0; y += 4.0) {
			vec4 value = texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * vec2(x, y));
			float p = -(pow(x, 2) + pow(y, 2)) / (2.0 * pow(sd, 2));
			sum += value * left * pow(e, p);
		}
	}
	COLOR = sum * 32.0 + texture(SCREEN_TEXTURE, SCREEN_UV);
}
