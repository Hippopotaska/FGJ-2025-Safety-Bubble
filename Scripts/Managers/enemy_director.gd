extends Node2D

class_name EnemyDirector

var enemy_melee_scene = preload("res://Scenes/enemy_melee.tscn")

static var active_enemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var enemy_instance = enemy_melee_scene.instantiate()
	get_tree().root.add_child(enemy_instance)
	enemy_instance.global_position = Vector2.ZERO
	active_enemies.append(enemy_instance)

static func destroy_enemy(enemy_to_remove: Node2D) -> void:
	active_enemies.erase(enemy_to_remove)
	enemy_to_remove.queue_free()
