extends Node


@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 20.0
@export var spawn_rate_per_minute: float = 60.0
@export var wave_duration: float = 20.0
@export var break_intensity: float = 0.5


var time: float = 0.0


func _process(delta: float) -> void:
	if GameManager.is_game_over: return
	
	time += delta
	
	# Linear spawn rate growth
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 120.0)
	
	# Sinusoidal wave for spawn rate
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
	spawn_rate *= wave_factor
	
	# Update spawn rate
	mob_spawner.mobs_rate = spawn_rate
