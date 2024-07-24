extends CharacterBody2D


const SPEED: float = 300.0 # 300
const JUMP_VELOCITY: float = -500.0 # - 400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Animation variables
var is_running = false
var is_hurt = false
# Movement variables
var direction: float

# Jump limit
var jump_limit = 2
var extra_jumps_count = 0
# Hurt moves variables
var knockback_vector: Vector2 = Vector2.ZERO
@onready var ray_right = $ray_right
@onready var ray_left = $ray_left


@export_category("Player status")
@export var player_life: int = 100
@export_category("Player texture")
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var remote_transform = $RemoteTransform2D


func _physics_process(delta):
	# Toggle running on sprint key press
	if Input.is_action_pressed("sprint"):
		is_running = true
	else:
		is_running = false
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Second jump
	elif Input.is_action_just_pressed("ui_accept") and extra_jumps_count < jump_limit:
		print("Extra jumps count:",extra_jumps_count+1)
		velocity.y = JUMP_VELOCITY
		extra_jumps_count += 1
	
		
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		# Sprite rotation
		rotate_with_scale(direction)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()

# Scale direction
func rotate_with_scale(direction):
	animated_sprite.scale.x = direction


# Toggle fliph to rotate sprite
func rotate_with_fliph(direction):
	if direction > 0: # Right direction
		animated_sprite.flip_h = false
	elif direction < 0: # Left direction
		animated_sprite.flip_h = true


func follow_camera(camera_node):
	var camera_path = camera_node.get_path()
	remote_transform.remote_path = camera_path
	pass
	

func take_damage(knockback_force: Vector2 = Vector2.ZERO,duration: float = 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween : = get_tree().create_tween()
		# Parallel hurt knockback movement and hurt color modulate
		# Knockback movement
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		# Hurt color modulate
		animated_sprite.modulate = Color(1,0,0, 1)
		knockback_tween.parallel().tween_property(animated_sprite, "modulate", Color(1, 1, 1, 1), duration)
	
	# States
	is_hurt = true
	await get_tree().create_timer(.3).timeout
	is_hurt = false
	pass
	
func _set_state():
	var state = "idle"
	
	# Reset jumps
	if is_on_floor():
		extra_jumps_count = 0
	if !is_on_floor():
		state = "jump"
		
	elif direction:
		if is_running:
			velocity.x *= 4
			state = "run"
		else:
			state = "walk"
	
	if is_hurt:
		state = "hurt"
		
	if animated_sprite.name != state:
		animated_sprite.play(state)


func _on_hurtbox_body_entered(body: Node2D):
	#if body.is_in_group("enemies"):
		#queue_free()
	# Player extinction on damage
	if player_life < 0:
		queue_free()
	else :
		if ray_right.is_colliding():
			take_damage(Vector2(-200, - 200))
		if ray_left.is_colliding():
			take_damage(Vector2(200, - 200))
		# One hit skillshot
		if body.is_in_group("skillshot"):
			body.queue_free()
	pass
	
