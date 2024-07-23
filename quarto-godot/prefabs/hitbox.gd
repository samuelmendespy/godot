extends Area2D


func _on_body_entered(body):
	print("Hitbox Test")
	if body.name == "Player":
		body.velocity.y = body.JUMP_VELOCITY
		owner.enemy_animation.play("hurt")
		print("Player detected")
	else:
		print(body.name)
