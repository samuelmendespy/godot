extends Node

var input_vector : Vector2 = Vector2(0, 0)
var main_player : Player

@onready var attack_1_shape = $"../HitBox/Attack1Shape"


func _ready():
	# Assign parent as enemy
	main_player = get_parent()

func _process(delta):
	# Read player input
	read_input()
	
	# Process attack cooldown duration
	#update_attack_cooldown(delta)
	
	# Detect action to start hit basic attack
	if Input.is_action_just_pressed("basic_attack"):
		basic_attack1()
	
func read_input():
	# Obter input vector
	input_vector = Input.get_vector("ui_left","ui_right", "ui_up", "ui_down")
	
	# Apagar deadzone do joystick para input_vector
	var deadzone_joystick = 0.15
	if abs(input_vector.x) < deadzone_joystick:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone_joystick:
		input_vector.y = 0
	
	# Atualizar isrunning
	main_player.was_running = main_player.isrunning
	main_player.isrunning = not input_vector.is_zero_approx()


# Tocar animação
func play_run_idle_animation():
	if not main_player.is_attacking:
		if main_player.was_running != main_player.isrunning:
			if main_player.isrunning:
				main_player.animation_player.play("run")
			else:
				main_player.animation_player.play("idle")

# Game logic to rotate sprite, change sprite sense
func sense_rotate_sprite():
	if input_vector.x > 0:
		# RIGHT SIDE
		main_player.sprite.flip_h = false # desmarcar flip_h do Sprited2D
		# FIXED COLLISION SHAPE FLIP
		attack_1_shape.position = Vector2(50.00, -27.00)
	elif input_vector.x < 0:
	# LEFT SIDE
		main_player.sprite.flip_h = true # marcar flip_h do Sprite2D
		# FIXED COLLISION SHAPE FLIP		
		attack_1_shape.position = Vector2(-50.00, -27.00)
		
# Attack
func basic_attack1():
	if main_player.is_attacking:
		return
	
	# Play hit animation
	main_player.animation_player.play("attack_basic_attack")
	
	# Set cooldown timer value
	main_player.hit_cooldown = 0.6
	 
	# Active attack flag
	main_player.is_attacking = true
