shader_type canvas_item;

uniform bool enabled = true;
uniform float blink_speed = 8.0;

void fragment() {
	if (enabled) {
		float ratio = (sin(blink_speed * TIME) + 1.0) / 2.0;
		vec4 color = texture(TEXTURE, UV);
		COLOR = mix(color, vec4(vec3(1.0), color.a), ratio);
	} else {
		COLOR = texture(SCREEN_TEXTURE, SCREEN_UV)
	}

}