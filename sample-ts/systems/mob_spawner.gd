extends Node

@export var creatures: Array[PackedScene]
@onready var path_follow_2d = %PathFollow2D

@export var mobs_rate : float = 30
var cooldown : float = 0.0



func _process(delta):
	# Timer
	cooldown -=delta
	if cooldown > 0 : return
	
	# Frequency : mobs per minute
	
	var interval = 60.0 / mobs_rate
	cooldown = interval
	
	# Instanciar uma criatura
	
	# - Pegar criatura aleatória
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	# - Pegar ponto aleatório
	var randomic_point = get_point()
	# - Instanciar cena
	var creature = creature_scene. instantiate() 
	# - Posicionar
	creature.global_position = randomic_point
	# creature.position = get_point()
	get_parent().add_child(creature)
	
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
