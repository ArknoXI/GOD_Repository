shader_type canvas_item;
void fragment() {
	COLOR = texture(TEXTURE, UV);
	float pos = 256.0;
	vec2 center = FRAGCOORD.xy / vec2(2);
    float d = distance(FRAGCOORD.xy, vec2(cos(TIME), sin(TIME)) * 128.0 + center) / pos;
    COLOR.rgb *= d;
}