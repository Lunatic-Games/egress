shader_type canvas_item;

uniform float margin;
uniform vec2 strength = vec2(10.0, 1.0);
uniform vec4 background_color: hint_color;

void fragment() {
	float x = SCREEN_UV.x - 0.5;
	float y = SCREEN_UV.y - 0.5;
	y *= strength.y * (1.0 - cos(x));
	x *= strength.x * (1.0 - cos(y));
	if (SCREEN_UV.y + y > 1.0 - margin * SCREEN_PIXEL_SIZE.y || 
			SCREEN_UV.y + y < margin * SCREEN_PIXEL_SIZE.y || 
			SCREEN_UV.x + x > 1.0 - margin * SCREEN_PIXEL_SIZE.x || 
			SCREEN_UV.x + x < margin * SCREEN_PIXEL_SIZE.x) {
		COLOR = background_color;
	} else {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(x, y));
	}
	
}