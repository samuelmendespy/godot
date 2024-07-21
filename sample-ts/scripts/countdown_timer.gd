extends Label

@export var countdown_limit_in_seconds: int = 120

var time_elapsed: float = 0.0
var time_elapsed_in_seconds: int = 0
var countdown_in_seconds: int = 0

var seconds: int = 0
var minutes: int = 0

func _process(delta):
	
	# Endgame if time is up
	if countdown_in_seconds <= 0:
		GameManager.end_game()
	else:
		time_elapsed += delta
		time_elapsed_in_seconds = floori(time_elapsed)
	
	GameManager.game_time_seconds = time_elapsed_in_seconds
	
	
	# Transform time played to mm:ss
	countdown_in_seconds = countdown_limit_in_seconds - time_elapsed_in_seconds
	
		
	seconds = countdown_in_seconds % 60
	minutes = countdown_in_seconds / 60
	
	text = "%02d:%02d" % [minutes, seconds]
	
