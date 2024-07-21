extends Node2D

# Defines the time to Start moving the platform
const WAIT_DURATION: float = 1.0

@onready var platform: AnimatableBody2D = $platform
@export_category("Platform settings")
@export var move_speed: float = 2.0
@export var distance: int = 760 # 2 x 380 (platform size)
@export var move_horizontal: bool = true

# Common
var follow = Vector2.ZERO
var platform_center : int = 190

func _ready():
	move_platform()
	
func _physics_process(delta):
	platform.position = platform.position.lerp(follow, 0.5)
	pass

func move_platform():
	# Ternary
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(move_speed * platform_center)
	
	var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
	platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(duration + (WAIT_DURATION * 1) )
	
	
	
	
	
