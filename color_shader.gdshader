shader_type canvas_item;
uniform vec3 col:source_color;
void fragment() {
	COLOR.rgb = min(COLOR.r * col + COLOR.b + COLOR.g,1.0);
	
	// Called for every pixel the material is visible on.
}