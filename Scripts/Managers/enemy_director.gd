extends Node2D

class_name EnemyDirector



var enemy_basic = preload("res://Scenes/Enemies/enemy_basic.tscn")
var enemy_fast = preload("res://Scenes/Enemies/enemy_fast.tscn")
var enemy_big = preload("res://Scenes/Enemies/enemy_big.tscn")
var enemy_fast_elite = preload("res://Scenes/Enemies/enemy_fast_elite.tscn")
var enemy_big_elite = preload("res://Scenes/Enemies/enemy_big_elite.tscn")

static var do_spawn = true

var difficulty_value = 0
var difficulty_state
enum DIFFICULTY {Easy = 1, Medium = 2, Hard = 3, Pain = 4, Suffering = 5, Death = 6}

var min = Vector2.ZERO
var max = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.game_over.connect(stop_enemies)
	SignalManager.game_reset.connect(reset_enemies)
	
	var rect = get_viewport_rect()
	var center = rect.get_center()
	min = Vector2(center.x - (rect.size.x * 0.5), center.y - (rect.size.y *0.5))
	max = Vector2(center.x + (rect.size.x * 0.5), center.y + (rect.size.y *0.5))
	
	difficulty_value = 0
	difficulty_state = DIFFICULTY.Suffering


func _on_timer_timeout() -> void:
	if (do_spawn):
		var spawn_value = randi_range(0, 100)
		if (difficulty_state == DIFFICULTY.Easy):
			spawn_enemy(enemy_basic.instantiate())
		elif (difficulty_state == DIFFICULTY.Medium):
			if (spawn_value < 20):
				spawn_enemy(enemy_fast.instantiate())
			else:
				spawn_enemy(enemy_basic.instantiate())
		elif (difficulty_state == DIFFICULTY.Hard):
			if (spawn_value <= 15):
				spawn_enemy(enemy_big.instantiate())
			elif (spawn_value > 15 and spawn_value <= 50):
				spawn_enemy(enemy_fast.instantiate())
			else:
				spawn_enemy(enemy_basic.instantiate())
		elif (difficulty_state == DIFFICULTY.Pain):
			if (spawn_value < 75):
				spawn_enemy(enemy_fast.instantiate())
			else:
				spawn_enemy(enemy_big.instantiate())
		elif (difficulty_state == DIFFICULTY.Suffering):
			if (spawn_value <= 20):
				spawn_enemy(enemy_fast_elite.instantiate())
			if (spawn_value > 20 and spawn_value <= 80):
				spawn_enemy(enemy_big.instantiate())
			else:
				spawn_enemy(enemy_fast.instantiate())
		elif (difficulty_state == DIFFICULTY.Death):
			if (spawn_value < 75):
				spawn_enemy(enemy_fast_elite.instantiate())
			else:
				spawn_enemy(enemy_big_elite.instantiate())
		else:
			spawn_enemy(enemy_basic.instantiate())

func spawn_enemy(enemy_instance: Node2D):
	%enemy_group.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()
	
func _on_difficulty_timer_timeout() -> void:
	if (GameManager.get_game_state() != 0):
		return
	
	%spawn_timer.wait_time = %spawn_timer.wait_time - 0.035
	difficulty_value += 1
	print_debug("Difficulty increased" + str(difficulty_value))
	GameManager.gain_score(difficulty_value * 100)
	if (difficulty_value == 4):
		difficulty_state = DIFFICULTY.Medium
		print_debug("Difficulty medium")
	elif (difficulty_value == 8):
		difficulty_state = DIFFICULTY.Hard
		print_debug("Difficulty hard")
	elif (difficulty_value == 12):
		difficulty_state = DIFFICULTY.Pain
		print_debug("Difficulty pain")
	elif (difficulty_value == 14):
		difficulty_value = DIFFICULTY.Suffering
		print_debug("Difficulty suffering")
	elif (difficulty_value == 16):
		difficulty_value = DIFFICULTY.Death
		print_debug("Difficulty death")

func get_spawn_position() -> Vector2:
	var rect = get_viewport_rect()
	var center = rect.get_center()
	var playerPos = GameManager.get_player_position()
	var direction = Vector2.from_angle(randf_range(0,360)).normalized()
	var position = Vector2(center.x + (direction.x * rect.size.x), center.y + (direction.y * rect.size.y))
	position.clamp(min, max)
	return position

func stop_enemies():
	do_spawn = false
	for entry in get_node("enemy_group").get_children():
		entry.stop_movement()
		
func reset_enemies():
	for entry in get_node("enemy_group").get_children():
		destroy_enemy(entry, true)
	do_spawn = true
	difficulty_state = DIFFICULTY.Easy
	difficulty_value = 0
	

static func destroy_enemy(enemy_to_remove: Node2D, killed_by_shield: bool) -> void:
	GameManager.gain_score(enemy_to_remove.score_gain)
	if (killed_by_shield == false):
		SignalManager.spawn_xp_shards.emit(enemy_to_remove.xp_drops, enemy_to_remove.global_position)
	enemy_to_remove.queue_free()
