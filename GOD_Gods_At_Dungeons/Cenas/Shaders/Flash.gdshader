shader_type canvas_item;

uniform bool is_active = false;

void fragment() {
	if (is_active){
		vec4 previus_color = texture(TEXTURE, UV);
		COLOR = vec4(1,1,1,previus_color.a);
	}
}
