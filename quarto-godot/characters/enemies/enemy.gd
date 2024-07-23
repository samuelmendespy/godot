extends CharacterBody2D


@onready var enemy_animation = $AnimationPlayer


func _on_animation_player_animation_finished(animation_name):
	if animation_name == "hurt":
		print("Remove enemy")
		queue_free()
