/*
pencil_mark.shader
Copyright (c) 2026 Vincent Bourgmayer
License: MIT
*/
shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec4 line_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);

void fragment() {
	vec4 wood_color = texture(TEXTURE, UV);
	float mark = texture(mask_texture, UV).r;
	COLOR = mix(wood_color, line_color, mark);
}
