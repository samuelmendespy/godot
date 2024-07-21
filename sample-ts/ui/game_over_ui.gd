class_name GameOverUI
extends CanvasLayer

@onready var time_survived_label: Label = %TimeSurvived
@onready var monsters_slain_label: Label = %MonstersSlain


@export var restart_delay: float = 15.0
var restart_cooldown: float


func _ready():
	# Time elapsed in seconds
	time_survived_label.text = "Time survived: %02d seconds" % [GameManager.game_time_seconds]
	# Monster slain count
	monsters_slain_label.text = "Monsters defeated: %02d" % [GameManager.monsters_slain]
	#monsters_label.text = str(GameManager.monsters_slain)
	restart_cooldown = restart_delay


func _process(delta):
	restart_cooldown -= delta
	# Auto restart game after cooldown 15 seconds
	if restart_cooldown <= 0.0:
		restart_game()


func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
