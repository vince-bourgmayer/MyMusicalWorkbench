/*
invisible_cloak.shader
Copyright (c) 2025-2026 Vincent Bourgmayer
License: MIT
*/
shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
    float m = texture(mask_texture, UV).r;
    if (m < 0.5) {
        discard;
    }
}
