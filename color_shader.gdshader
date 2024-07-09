shader_type canvas_item;
uniform bool enabled = false;
uniform vec3 note_color:source_color;
void fragment(){
	vec4 finalColor = texture(TEXTURE,UV);
   if (enabled) {
            float diff = finalColor.r - ((finalColor.g + finalColor.b) / 2.0);
            COLOR = vec4(((finalColor.g + finalColor.b) / 2.0) + (note_color.r * diff), finalColor.g + (note_color.g * diff), finalColor.b + (note_color.b * diff),COLOR.a);

        } else
            COLOR = finalColor;
 }
