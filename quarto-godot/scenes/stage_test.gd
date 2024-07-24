extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D

func _ready():
	player.follow_camera(camera)
