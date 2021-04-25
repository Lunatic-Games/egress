shader_type canvas_item;

uniform float inner_radius : hint_range(0, 0.5);
uniform float min_length : hint_range(0, 0.5) = 0.2;
uniform float max_length : hint_range(0, 0.5) = 0.5;
uniform int bars : hint_range(2, 256);
uniform float seed;
uniform float rotation_speed;
uniform float pulsate_speed;
uniform float pulsate_strength;

// https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float rand(float value) {
	return fract(sin(dot(vec2(value, seed), vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rotate(vec2 uv, float rotation) {
	vec2 rotated;
	rotated.x = uv.x * cos(rotation) - uv.y * sin(rotation);
	rotated.y = uv.x * sin(rotation) + uv.y * cos(rotation);
	return rotated;
}

void fragment() {
	vec2 xy = rotate(UV - 0.5, TIME * rotation_speed);
	
	float angle = (atan(xy.y / xy.x));
	float sect = mod(angle - mod(angle, 3.14159 / float(bars)), 3.14159);
	float radius = min_length + rand(sect) * (max_length - min_length);
	radius += pulsate_strength * sin(rand(sect) * 6.282 + TIME * pulsate_speed);
	if (pow(xy.x, 2) + pow(xy.y, 2) < pow(radius, 2) &&
			pow(xy.x, 2) + pow(xy.y, 2) > pow(inner_radius, 2)) {
		COLOR = vec4(1.0);
	} else {
		COLOR = vec4(0.0);
	}
}