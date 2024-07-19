class_name Player
extends CharacterBody2D

@export var health: int = 100
@export var max_health: int = 100
@export var speed: float = 7
@export var base_damage: int = 1

@export var extinction_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var punch_hitbox: Area2D = $HitBox
@onready var vulnerable_hitbox: Area2D = $VulnerableHitBox
@onready var health_progress_bar: ProgressBar = $HealthProgressBar
@onready var player_controller = $PlayerController

@onready var attack_1_shape = $HitBox/Attack1Shape



var isrunning : bool = false
var was_running : bool = false
var is_attacking : bool = false

var hit_cooldown : float = 0.0
var taint_cooldown: float = 0.0
var toxic_damage: int = 1


func _process(delta):
	# Inject player position and velocity on GameManager
	GameManager.player_position = position
	GameManager.player_velocity = velocity
	
	# Read player input
	player_controller.read_input()
	
	# Process attack cooldown duration
	update_attack_cooldown(delta)

	# Process sprite animation and rotation to set sense
	player_controller.play_run_idle_animation()
	player_controller.sense_rotate_sprite()
	
	# Detect and calculate taint damage to player
	update_char_hitbox_detection(delta)
	
	# Update ProgressBar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
	
func _physics_process(delta):
	# Alterar velocidade
	var target_velocity = player_controller.input_vector * speed * 100
	
	if is_attacking:
		target_velocity *= 0.25
	
	velocity = lerp(velocity, target_velocity, 0.3) # smaller lerp weight to slip more after walk
	move_and_slide()
	
	
func update_attack_cooldown(delta: float):
	# Update Attack timer
	if is_attacking:
		hit_cooldown -= delta # calc is 0.6s - 1/60 = 0.584 where 0.6s is right_attack animation duration
		if hit_cooldown <= 0.0:
			is_attacking = false
			isrunning = false
			animation_player.play("idle")
	
func basic_attack1():
	if is_attacking:
		return
	
	# Play hit animation
	animation_player.play("attack_basic_attack")
	
	# Set cooldown timer value
	hit_cooldown = 0.6
	 
	# Active attack flag
	is_attacking = true

# Damage dealt by toxicity of monsters near to player	
func update_char_hitbox_detection(delta):
	# Timer
	taint_cooldown -= delta
	if taint_cooldown > 0: return
	
	taint_cooldown = 0.5
	
	get_tree().create_timer(3.0).timeout
	# Damage frequence
	# Enemies near char
	var units = vulnerable_hitbox.get_overlapping_bodies()
	for unit in units:
		if unit.is_in_group("enemies"):
			damage(1)


func restore_health(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	print("Player health restored in", amount)

func deal_damage_to_enemies():
	# Detect enemies in contact with the hit box
	var creatures = punch_hitbox.get_overlapping_bodies()
	for creature in creatures:
		if creature.is_in_group("enemies"):
			var enemy: Enemy = creature
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction : Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
				print("left")
			else:
				attack_direction = Vector2.RIGHT
				print("Right")
			var dot_product = direction_to_enemy.dot(attack_direction)
			print("Dot: ", dot_product)
			#
			# Send damage to the enemy
			enemy.damage(base_damage)
 

func damage(amount: int):
	if health <= 0 : return
	
	health -= amount
	#print("Player received damage:", amount)
	#print("Player Health: ", health)
	
	# Colorize on damage
	modulate = Color.FIREBRICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	
	# Check health status
	if health <= 0:
		trigger_extinction()

func trigger_extinction():
	if extinction_scene:
		var extinction_object = extinction_scene.instantiate()
		extinction_object.position = position
		get_parent().add_child(extinction_object)
		
	queue_free()
