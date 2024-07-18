extends Node

@export var speed: float = 1.00

var enemy: Enemy
var sprite_cpu: AnimatedSprite2D

func _ready():
	# Assign parent as enemy
	enemy = get_parent()
	sprite_cpu = enemy.get_node("AnimatedSprite2D")
	

func _physics_process(delta):
	
# Retrieve GameManger value of player_position
	var player_position = GameManager.player_position

	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()

# Game logic to rotate sprite, change sprite sense
	if input_vector.x > 0:
		sprite_cpu.flip_h = false # desmarcar flip_h do Sprited2D
	elif input_vector.x < 0:
		sprite_cpu.flip_h = true # marcar flip_h do Sprite2D
	
