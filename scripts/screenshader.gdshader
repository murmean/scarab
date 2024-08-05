shader_type canvas_item;

uniform sampler2D gradient;
uniform float noise_amount : hint_range(0, 1);
uniform sampler2D noise;


float random (vec2 uv) {
    return fract(sin(dot(uv.xy * TIME,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec3 texture_input = texture(noise, UV * random(UV)).rgb;
	vec3 gradient_input = texture(gradient, UV).rgb;
	COLOR.a = COLOR.a - texture_input.r - noise_amount;
	COLOR.rgb = gradient_input; 
}

