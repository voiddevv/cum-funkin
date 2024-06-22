shader_type canvas_item;
uniform float intensity = 0.0;
uniform int amount = 200;
float drawCircle(vec2 uv,vec2 center, float radius) {
    return 1.0 - smoothstep(0.0, radius, length(uv - center));
}
float rnd(float x) {
    return fract(sin(dot(vec2(x + 48.0, 38.0 / (x + 2.5)), vec2(13.0, 78.0))) * (43758.0));
}
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;
void fragment() {
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV);
	
	vec2 uv = UV;
	uv.x *= 2.0;
	for(int i=0; i<amount; i++) {
        float j = float(i) * 2.0;
        float realIntensity = intensity * 1.0;
        float speed = (0.3+rnd(cos(j))*(0.7+0.5*cos(j/(float(amount)*0.25))));
        vec2 center = vec2(((0.5-uv.y)*realIntensity+rnd(j)+0.1*(cos(TIME+sin(j)))) * 2.0, mod(sin(j)+speed*(TIME*1.5*(0.1+realIntensity)), 1.0));
        COLOR += vec4(0.45*drawCircle(uv,center, 0.001+speed*(intensity/(0.2 / 1.5))*0.012));
    }
}