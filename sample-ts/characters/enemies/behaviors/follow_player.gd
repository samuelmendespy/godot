extends Node

@export var speed: float = 1.00

var enemy: Enemy
var sprite_cpu: AnimatedSprite2D
var difference: Vector2

func _ready():
	# Assign parent as enemy
	enemy = get_parent()
	sprite_cpu = enemy.get_node("AnimatedSprite2D")
	

func _physics_process(delta):
	
# Retrieve GameManger value of player_position
	var player_position = GameManager.player_position

	# Set difference value
	difference = player_position - enemy.position
	
	# Hotfix to enemy attached to player
	if difference.x < 50 and difference.y < 80:
		if difference.x > -90 and difference.y > 0:
			difference.x = 120
			difference.y = 90

	var input_vector = difference.normalized()
	enemy.velocity = input_vector * speed * 200.0
	enemy.move_and_slide()
	print("Difference", difference)
	print("Input Vector", input_vector)
	print(" === ")
	
# Game logic to rotate sprite, change sprite sense
	if input_vector.x > 0:
		sprite_cpu.flip_h = false # desmarcar flip_h do Sprited2D
	elif input_vector.x < 0:
		sprite_cpu.flip_h = true # marcar flip_h do Sprite2D
	
