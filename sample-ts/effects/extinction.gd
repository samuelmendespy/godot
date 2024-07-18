extends AnimatedSprite2D

func _ready():
	play()
	
	# Wait 3 seconds to remove
	await get_tree().create_timer(3.0).timeout
	queue_free()
