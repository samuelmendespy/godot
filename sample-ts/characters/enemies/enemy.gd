class_name Enemy
extends Node2D


@export var extinction_scene: PackedScene

@export var health: int = 10

func damage(amount: int):
	health -= amount
	print("Enemy received damage:", amount, "Health points:", health)
	
	# Check health status
	if health <= 0:
		trigger_extinction()

func trigger_extinction():
	if extinction_scene:
		var extinction_object = extinction_scene.instantiate()
		extinction_object.position = position
		get_parent().add_child(extinction_object)
		
	queue_free()

