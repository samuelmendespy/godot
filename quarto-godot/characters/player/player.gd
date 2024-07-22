extends CharacterBody2D


const SPEED: float = 300.0 # 300
const JUMP_VELOCITY: float = -1000.0 # - 400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping: bool = false

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Input track
var last_input_direction: Vector2 = Vector2.ZERO
var current_input_direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		
		# Sprite rotation
		rotate_with_scale(direction)
		#rotate_with_fliph(direction)
		
		# Check if is jumping
		if !is_jumping:
			animated_sprite.play("run")
	elif is_jumping:
		animated_sprite.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")

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
