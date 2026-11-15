shader_type canvas_item;

uniform sampler2D geometry_data;
uniform sampler2D surface_data;
uniform sampler2D thickness_data; // Thickness mask (1 = intact, 0 = Dropped)
uniform sampler2D raw_wood_data; 


uniform float overlay_intensity = 1.0;     // Permet de doser l'effet visuel

uniform vec4 line_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);

void fragment() {

	// 1. shape: drop everything outside the contour
	if (texture(geometry_data, UV).r < 0.5) {
		discard;
	}

	// 2. base wood + rough layer, which fades out as the wood gets planed
	vec4 wood = texture(TEXTURE, UV);
	vec4 raw = texture(raw_wood_data, UV);
	float raw_alpha = clamp(texture(thickness_data, UV).r * overlay_intensity, 0.0, 1.0) * raw.a;
	vec3 color = mix(wood.rgb, raw.rgb, raw_alpha);

	// 3. pencil marks on top
	float mark = texture(surface_data, UV).r;
	color = mix(color, line_color.rgb, mark * line_color.a);

	COLOR = vec4(color, wood.a);
}
