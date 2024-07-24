class_name ElectricField
extends Area2D

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
	# Invert dir
	direction = dir * -1
	if dir < 0:
		scale.x = -1
	else :
		scale.x = 1
