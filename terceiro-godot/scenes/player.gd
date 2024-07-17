extends CharacterBody2D


@export var speed = 4.0
@export_range(0, 1) var lerp_factor = 0.5
@onready var sprite = %Sprite


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_velocity = direction * speed * 100
	velocity = lerp(velocity, target_velocity, 0.5)

	move_and_slide()
	
	var target_rotation = direction.x * 50
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, lerp_factor)
