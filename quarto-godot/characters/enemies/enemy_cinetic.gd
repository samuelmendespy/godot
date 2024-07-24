extends CharacterBody2D

# Nodes variables
@onready var enemy_animation = $AnimationPlayer
@onready var skill_spawn_point = $skill_spawn_point
@onready var ground_detector = $ground_detector
@onready var player_detector = $player_detector
@onready var body = $body
const ELECTRIC_FIELD = preload("res://effects/electric_field.tscn")

# Movement variables
var direction: float = 1.0
var SPEED : float = 50.0

# Enemy status
var health_points = 0

func _physics_process(delta):
	
	# Invert enemy movement
	if is_on_wall():
		flip_enemy()
	
	if !ground_detector.is_colliding():
		flip_enemy()
		
	if player_detector.is_colliding():
		#spawn_eletric_field()
		enemy_animation.play("shooting")
	else:
		enemy_animation.play("idle")
	
	velocity.x = SPEED * direction
	
	move_and_slide()
	
func flip_enemy():
	direction *= -1
	body.scale.x *= -1
	player_detector.scale.x *= -1
	skill_spawn_point.position.x *= -1
	
func _on_animation_player_animation_finished(animation_name):
	if animation_name == "hurt":
		print("Play idle again")
		await get_tree().create_timer(.5).timeout
		enemy_animation.play("idle")

func spawn_eletric_field():
	var new_eletric_field = ELECTRIC_FIELD.instantiate()
	if direction == 1: # right side
		new_eletric_field.rotate_with_scale(1)
	elif direction == -1: # left side
		new_eletric_field.rotate_with_scale(-1)
		
	add_sibling(new_eletric_field)
	new_eletric_field.global_position = skill_spawn_point.global_position
