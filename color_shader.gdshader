shader_type canvas_item;
uniform vec3 col:source_color;
void fragment() {
	COLOR.rgb = COLOR.r * col + COLOR.b + COLOR.g;
	// Called for every pixel the material is visible on.
}