extends Node2D

var value: int = 100

func _ready():
	%Label.text = str(value)
