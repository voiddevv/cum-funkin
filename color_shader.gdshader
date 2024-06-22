shader_type canvas_item;

void vertex() {
	VERTEX.x += sin(PI * TIME + VERTEX.y)*250.0;
	// Called for every vertex the material is visible on.
}
uniform vec3 col:source_color;
void fragment() {
	COLOR.rgb = COLOR.r * col + COLOR.b + COLOR.g;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
