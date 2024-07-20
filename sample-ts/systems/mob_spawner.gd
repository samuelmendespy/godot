class_name MobSpawner
extends Node

@export_category("Spawn Settings")
@export var mobs_rate : float = 30
@export var creatures: Array[PackedScene]

@export_category("Spawn Area")
@onready var path_follow_2d = %PathFollow2D

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
