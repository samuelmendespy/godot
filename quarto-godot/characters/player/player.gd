extends CharacterBody2D


const SPEED: float = 300.0 # 300
const JUMP_VELOCITY: float = -1000.0 # - 400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping: bool = false

var is_running = false

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D



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
			if is_running:
				velocity.x *= 4
				animated_sprite.play("run")
			else:
				animated_sprite.play("walk")
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
		

