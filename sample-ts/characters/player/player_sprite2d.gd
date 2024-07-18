extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@export var speed: float = 7

var input_vector : Vector2 = Vector2(0, 0)
var isrunning : bool = false
var was_running : bool = false
var is_attacking : bool = false

var hit_cooldown : float = 0.0

func _process(delta):
	# Read player input
	read_input()
	
	# Process attack cooldown duration
	update_attack_cooldown(delta)
	
	# Detect action to start hit basic attack
	if Input.is_action_just_pressed("basic_attack"):
		protagonist_attack()
	
	# Process sprite animation and rotation to set sense
	play_run_idle_animation()
	sense_rotate_sprite()
	
	

func _physics_process(delta):
	# Alterar velocidade
	var target_velocity = input_vector * speed * 100
	
	if is_attacking:
		target_velocity *= 0.25
	
	velocity = lerp(velocity, target_velocity, 0.3) # smaller lerp weight to slip more after walk
	move_and_slide()
	

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
	was_running = isrunning
	isrunning = not input_vector.is_zero_approx()
	
func update_attack_cooldown(delta: float):
	# Update Attack timer
	if is_attacking:
		hit_cooldown -= delta # calc is 0.6s - 1/60 = 0.584 where 0.6s is right_attack animation duration
		if hit_cooldown <= 0.0:
			is_attacking = false
			isrunning = false
			animation_player.play("idle")
	
# Tocar animação
func play_run_idle_animation():
	if not is_attacking:
		if was_running != isrunning:
			if isrunning:
				animation_player.play("run")
			else:
				animation_player.play("idle")
	

# Game logic to rotate sprite, change sprite sense
func sense_rotate_sprite():
	if input_vector.x > 0:
		sprite.flip_h = false # desmarcar flip_h do Sprited2D
	elif input_vector.x < 0:
		sprite.flip_h = true # marcar flip_h do Sprite2D
	

func protagonist_attack():
	if is_attacking:
		return
	
	# Play hit animation
	animation_player.play("attack_basic_attack")
	
	# Set cooldown timer value
	hit_cooldown = 0.6
	 
	# Active attack flag
	is_attacking = true
