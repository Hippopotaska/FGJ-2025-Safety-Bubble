extends Node2D

class_name EnemyDirector

var enemy_melee_scene = preload("res://Scenes/enemy_melee.tscn")

static var do_spawn = true

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
		var enemy_instance = enemy_melee_scene.instantiate()
		%enemy_group.add_child(enemy_instance)
		enemy_instance.global_position = get_spawn_position()

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
	

static func destroy_enemy(enemy_to_remove: Node2D) -> void:
	GameManager.gain_score(50)
	enemy_to_remove.queue_free()
