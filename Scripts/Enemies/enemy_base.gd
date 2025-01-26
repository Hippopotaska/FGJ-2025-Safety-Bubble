extends Node2D

class_name EnemyBase

var xp_shard = preload("res://Scenes/xp_shard.tscn")

var score_gain = 50
var do_movement = true
var move_direction
var move_speed = 80
var xp_drops = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (do_movement):
		move_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += move_direction * move_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 16):
		for i in xp_drops:
			var xp = xp_shard.instantiate()
			var randPos = Vector2(randf_range(-10,10), randf_range(-10,10))
			xp.global_position = global_position + randPos
			get_tree().root.get_node("main/xp_group").call_deferred("add_child",xp)
			area.get_parent().queue_free()
			EnemyDirector.destroy_enemy(self)

func stop_movement():
	do_movement = false
