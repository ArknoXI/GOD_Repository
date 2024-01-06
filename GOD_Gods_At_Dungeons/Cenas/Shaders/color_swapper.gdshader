shader_type canvas_item;

uniform vec4 color: source_color;
uniform bool is_active = false;


void fragment() {
	// Called for every pixel the material is visible on.
	vec4 curr_color = texture(TEXTURE, UV);
	if (curr_color.rba == vec3(0, 0, 1) && curr_color.g > 0.0)
	{
	 COLOR.rgb = color.rgb * curr_color.g;	
	}
	if (is_active){
		vec4 previus_color = texture(TEXTURE, UV);
		COLOR = vec4(1,1,1,previus_color.a);
	}
}
