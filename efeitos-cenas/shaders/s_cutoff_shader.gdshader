shader_type spatial;
uniform vec4 border_color: source_color;
uniform mat4 cutplane;
varying vec3 wvtx;
uniform sampler2D _albedo: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
	wvtx = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 planeNormal = normalize(cutplane[2].xyz);
	float planeDistance = dot(planeNormal,cutplane[3].xyz);
	float vertexDistance = dot(planeNormal, wvtx);
	float dist = vertexDistance - planeDistance;
	
	if (dist < 0.0) discard;
	
	//vec2 base_uv = UV;
	//vec4 albedo_tex = texture(texture_albedo,base_uv);
	
	//Add border
	//float border_dist = smoothstep(0.0,0.1,dist);
	//ALBEDO =  (mix(border_color *7.0,albedo_tex, border_dist)).rgb;
	
	ALBEDO = texture(_albedo, UV).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
