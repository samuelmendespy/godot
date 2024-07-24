extends Area2D


# Node variables
#@onready var collision_shape = $CollisionShape2D
@onready var eletric_collision_shape = $EletricCollisionShape

# Movement variables
var SPEED : float = 50.0
var direction : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= SPEED * direction * delta

func rotate_with_scale(dir):
	direction = dir
	$EletricCollisionShape.scale.x = dir
