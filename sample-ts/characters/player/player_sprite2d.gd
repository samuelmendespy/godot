extends CharacterBody2D

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@export var speed: float = 3

var isrunning : bool = false

#func _process(delta):
	#if Input.is_action_just_pressed("spacebar"):
		#print("Spacebar pressed!")
		#if isrunning:
			#animation_player.play("idle")
			#isrunning = false
		#else:
			#animation_player.play("run")
			#isrunning = true

func _physics_process(delta):
	# Obter input vector
	var input_vector = Input.get_vector("ui_left","ui_right", "ui_up", "ui_down", 0.15)
	# Akterar velocidade
	var target_velocity = input_vector * speed * 100
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()
 
	# Atualizar isrunning
	var was_running = isrunning
	isrunning = not input_vector.is_zero_approx()
	
	# Tocar animação
	if was_running != isrunning:
		if isrunning:
			animation_player.play("run")
		else:
			animation_player.play("idle")
		pass
