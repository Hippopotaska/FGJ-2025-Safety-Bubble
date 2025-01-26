extends Node2D

class_name EnemyDirector

var enemy_basic = preload("res://Scenes/Enemies/enemy_basic.tscn")
var enemy_fast = preload("res://Scenes/Enemies/enemy_fast.tscn")
var enemy_big = preload("res://Scenes/Enemies/enemy_big.tscn")

static var do_spawn = true

var difficulty = 0

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
	
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	if (do_spawn):
		var spawn_value = randi_range(0, 100)
		var enemy_instance
		if (difficulty >= 2):
			if (spawn_value < 20):
				spawn_enemy(enemy_fast.instantiate())
			else:
				spawn_enemy(enemy_basic.instantiate())
		elif (difficulty >= 4):
			if (spawn_value < 16):
				spawn_enemy(enemy_big.instantiate())
			elif (spawn_value > 15 and spawn_value <= 50):
				spawn_enemy(enemy_fast.instantiate())
			else:
				spawn_enemy(enemy_basic.instantiate())
		elif (difficulty >= 8):
			if (spawn_value < 75):
				spawn_enemy(enemy_fast.instantiate())
			else:
				spawn_enemy(enemy_big.instantiate())
		else:
			spawn_enemy(enemy_basic.instantiate())

func spawn_enemy(enemy_instance: Node2D):
	%enemy_group.add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()
	
func _on_difficulty_timer_timeout() -> void:
	%spawn_timer.wait_time = %spawn_timer.wait_time - 0.05
	difficulty += 1
	GameManager.gain_score(difficulty * 100)

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
		destroy_enemy(entry)
	do_spawn = true
	difficulty = 0
	

static func destroy_enemy(enemy_to_remove: Node2D) -> void:
	GameManager.gain_score(enemy_to_remove.score_gain)
	enemy_to_remove.queue_free()
