extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		body.velocity.y = body.JUMP_VELOCITY
		owner.enemy_animation.play("hurt")
		print("Player detected")
