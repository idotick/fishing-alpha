shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

uniform bool glitch;
uniform vec4 glitch_tint : source_color;
uniform sampler2D water_texture : source_color, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 shader = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 water = texture(water_texture, SCREEN_UV);
	
	if (glitch) {
		water = mix(water, glitch_tint, 0.5);
	}
	shader = mix(water, shader, 0.6);
	
	COLOR = shader;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
