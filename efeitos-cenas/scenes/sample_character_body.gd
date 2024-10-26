@tool
extends MeshInstance3D

# Flag to ensure the operation runs only once
var is_initialized: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_initialized:
		var cutoff_surface:MeshInstance3D = get_node("../Portal/mirror");
		material_override.set_shader_parameter("cutplane", cutoff_surface.transform);
		is_initialized = true # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass
