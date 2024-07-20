class_name Enemy
extends Node2D


@export var health: int = 10
@export var extinction_scene: PackedScene

var damage_digit_prefab: PackedScene
@onready var damage_position_marker = $Marker2D

@export_category("Drops")
@export var drop_event_rate: float = 0.5
@export var drop_event_rates: Array[float]
@export var drop_loot: Array[PackedScene]


func _ready():
	damage_digit_prefab = preload("res://effects/DamageDigits.tscn")
func damage(amount: int):
	health -= amount
	print("Enemy received damage:", amount, "Health points:", health)
	
	# Colorize on damage
	modulate = Color.FIREBRICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Display DamageDigits
	var damage_display = damage_digit_prefab.instantiate()
	damage_display.value = amount
	if damage_position_marker:
		damage_display.global_position = damage_position_marker.global_position
	else:
		damage_display.global_position = global_position
	get_parent().add_child(damage_display)
	
	# Check health status
	if health <= 0:
		if drop_loot.size() < 1:
			trigger_extinction()
		else:
			if randf() <= drop_event_rate:
				drop_item()
			else:
				trigger_extinction()

func trigger_extinction():
	if extinction_scene:
		var extinction_object = extinction_scene.instantiate()
		extinction_object.position = position
		get_parent().add_child(extinction_object)
		
	# Remove enemy node
	queue_free()

func drop_item():
	var dropped = get_random_drop_item().instantiate()
	dropped.position = position
	get_parent().add_child(dropped)
	
	# Remove enemy node
	queue_free()
	
	
# Function to select a random item drop
func get_random_drop_item() -> PackedScene:

	
	# SPECIAL CASE for loots with just 1 item
	if drop_loot.size() == 1:
		return drop_loot[0]

	# Calculate max chance
	var max_chance: float = 0.0
	for drop_event_rate in drop_event_rates:
		max_chance += drop_event_rate
		
	# Generate random value
	var random_value = randf() * max_chance
	
	# Select random item to drop
	var needle: float = 0.0
	for i in drop_loot.size():
		var drop_item = drop_loot[i]
		var drop_chance = drop_event_rates[i] if 1 < drop_event_rates.size() else 1
		if random_value <= drop_chance + needle :
			return drop_item
		needle += drop_chance
	return drop_loot[0]
