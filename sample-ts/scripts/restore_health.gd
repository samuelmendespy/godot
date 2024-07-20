extends Node


var curative
var curative_collection_area: Area2D

func _ready():
	curative = get_parent()
	
	# Play curative object animation
	if curative is AnimatedSprite2D:
		curative.play()
		
	curative.get_node("Area2D").body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.restore_health(curative.regeneration_amount)
		curative.queue_free()
