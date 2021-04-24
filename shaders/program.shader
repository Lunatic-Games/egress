shader_type canvas_item;

uniform float inner_radius : hint_range(0, 0.5);
uniform int bars : hint_range(2, 256);
uniform float seed;
uniform vec4 color : hint_color;
uniform float offset;

// https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float rand(float value) {
	return fract(sin(dot(vec2(value, seed), vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 xy = UV - 0.5;
	float angle = atan(xy.y / xy.x);
	float sect = angle - mod(angle, 3.14159 / float(bars));
	float radius = inner_radius + rand(sect) * 0.3;
	if (pow(xy.x, 2) + pow(xy.y, 2) < pow(radius, 2) &&
			pow(xy.x, 2) + pow(xy.y, 2) > pow(inner_radius, 2)) {
		COLOR = color;
	} else {
		COLOR = vec4(0.0);
	}
}