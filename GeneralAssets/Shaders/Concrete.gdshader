shader_type spatial;

// Uniforms for the Inspector
uniform vec3 base_color : source_color = vec3(0.5, 0.5, 0.5);
uniform vec3 aggregate_color : source_color = vec3(0.4, 0.4, 0.4);
uniform sampler2D noise_img : source_color, repeat_enable;
uniform sampler2D normal_img : hint_normal, repeat_enable;
uniform float uv_scale = 0.5;
uniform float sharpness : hint_range(0.0, 50.0) = 10.0;

// Function: Helper to calculate triplanar texture blending
vec3 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec3 samp = vec3(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy).rgb * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz).rgb * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy).rgb * p_weights.x;
	return samp;
}

void fragment() {
	// Function: Determine blending weights based on the surface normal
	vec3 blending = abs(NORMAL);
	blending /= (blending.x + blending.y + blending.z);
	blending = pow(blending, vec3(sharpness)); // Increases transition sharpness
	blending /= (blending.x + blending.y + blending.z);

	// Function: Define world-space coordinates for the projection
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz * uv_scale;

	// Function: Sample Albedo and Normal using triplanar logic
	vec3 albedo_samp = triplanar_texture(noise_img, blending, world_pos);
	vec3 normal_samp = triplanar_texture(normal_img, blending, world_pos);

	float noise_large = triplanar_texture(noise_img, blending, world_pos * 0.2).r;
	albedo_samp.r *= noise_large; // Darkens/Lightens large patches to break the pattern

	// Function: Final output assignment
	ALBEDO = mix(base_color, aggregate_color, albedo_samp.r);
	NORMAL_MAP = normal_samp;
	ROUGHNESS = 0.99;
	
}