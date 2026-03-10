////////////////////////// muzzle_flash_shader_face.gdshader /////////////////////////
// Billboard muzzle flash shader (front/back view).
// Made by shadecore_dev, 2025.

shader_type spatial;

uniform float emission = 1.0; // Color multiplier
uniform sampler2D main_tex : filter_nearest; // Main texture

uniform float face_threshold = 0.1; // 0.0-1.0 Angle threshold for revealing the billboard when the camera gets close to Z axis.

void vertex() {
	vec3 face_vec3 = -MODEL_MATRIX[1].xyz;
	vec4 face_vec4 = -MODEL_MATRIX[1];
	
	float vec_dif = abs(dot(MODEL_MATRIX[0].xyz, CAMERA_DIRECTION_WORLD));
	
	MODELVIEW_MATRIX = VIEW_MATRIX * 
	mat4(
		vec4(normalize(cross(face_vec3, INV_VIEW_MATRIX[2].xyz)), 0.0),
		face_vec4,
		vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, face_vec3)), 0.0),
		MODEL_MATRIX[3]
	);
}

void fragment() {
	float vec_dif = abs(dot(MODEL_MATRIX[0].xyz, CAMERA_DIRECTION_WORLD));
	vec4 color = texture(main_tex, UV);

	ALBEDO = color.rgb;
	EMISSION = color.rgb * emission;
	ALPHA = color.a * max(0.0, 0.5 - max(0.0, 1.0 - vec_dif - face_threshold));
}

///////////////////////////////////////////////////////////////////////////////////////