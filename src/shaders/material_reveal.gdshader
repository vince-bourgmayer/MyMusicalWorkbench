/*
material_reveal.shader
Copyright (c) 2026 Vincent Bourgmayer
License: MIT
*/
shader_type canvas_item;

uniform sampler2D thickness_mask_texture; // Thickness mask (1 = intact, 0 = Dropped)
uniform float overlay_intensity = 1.0;     // Permet de doser l'effet visuel

void fragment() {
    vec2 uv = UV;

    // Couleur de la surcouche (texture brute)
    vec4 overlay_color = texture(TEXTURE, uv);

    // Valeur du masque d'épaisseur (L8 -> canal R)
    float thickness_value = texture(thickness_mask_texture, uv).r;

    // Plus le bois est raboté, moins la surcouche est visible
    float overlay_alpha = clamp(thickness_value * overlay_intensity, 0.0, 1.0);

    // Applique la transparence à la surcouche
    COLOR = vec4(
        overlay_color.rgb,
        overlay_color.a * overlay_alpha
    );
}
