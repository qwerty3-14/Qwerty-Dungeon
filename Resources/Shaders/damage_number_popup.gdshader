shader_type canvas_item;


void fragment() {
 	if (COLOR.a == 0.0) {
		if (texture(TEXTURE, vec2(UV.x, UV.y - TEXTURE_PIXEL_SIZE.y)).a > 0.0 
		|| texture(TEXTURE, vec2(UV.x, UV.y + TEXTURE_PIXEL_SIZE.y)).a > 0.0
		|| texture(TEXTURE, vec2(UV.x - TEXTURE_PIXEL_SIZE.y, UV.y)).a > 0.0
		|| texture(TEXTURE, vec2(UV.x + TEXTURE_PIXEL_SIZE.y, UV.y)).a > 0.0) {
			
			COLOR.rgba = vec4(0.0, 0.0, 0.0, 1.0);
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
