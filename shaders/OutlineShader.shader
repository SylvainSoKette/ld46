shader_type canvas_item;

uniform float width: hint_range(0.0, 8.0);
uniform vec4 outline_color: hint_color;

void fragment()
{	
	vec4 sprite_color = texture(TEXTURE, UV);
	float alpha = -4.0 * sprite_color.a;

	float offset = width * 1.0 / float(textureSize(TEXTURE, 0).x);
	alpha += texture(TEXTURE, UV + vec2(offset, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-offset, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, offset)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -offset)).a;

	vec4 final_color = mix(sprite_color, outline_color, alpha);

	COLOR = vec4(
		final_color.rgb,
		clamp(abs(alpha) + sprite_color.a, 0.0, 1.0)
	);
}
