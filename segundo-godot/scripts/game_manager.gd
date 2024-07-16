extends Node

@export var object_templates: Array[PackedScene]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				spawn_new_object(event.position)

func spawn_new_object(position: Vector2):
	var index: int = randi_range(0, object_templates.size() - 1)
	var single_object_template = object_templates[index]
	var sp_object = single_object_template.instantiate()
	sp_object.position = position
	add_child(sp_object)
