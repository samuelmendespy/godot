extends CharacterBody2D

@export var speed: float = 1.00


func _physics_process(delta):
	
# Retrieve GameManger value of player_position
	var player_position = GameManager.player_position

	var difference = player_position - position
	var input_vector = difference.normalized()
	velocity = input_vector * speed * 100.0
	move_and_slide()
