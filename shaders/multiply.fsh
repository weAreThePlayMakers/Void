
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
	vec4 newColor = Texel(texture, texture_coords);
	
	float brightness = (newColor.r + newColor.g + newColor.b);

	return vec4(newColor.r * brightness, newColor.g * brightness, newColor.b * brightness, newColor.a);
}