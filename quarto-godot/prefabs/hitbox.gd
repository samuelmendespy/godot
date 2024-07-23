extends Area2D


func _on_body_entered(body):
	print("Hitbox Test")
	if body.name == "Player":
		print("Player detected")
	else:
		print(body.name)
