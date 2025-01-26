extends Node2D

class_name EnemyBase

@export var score_gain = 50
var do_movement = true
var move_direction
@export var move_speed = 80
@export var xp_drops = 1
var is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (do_movement):
		move_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += move_direction * move_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 16 and is_dead == false):
		is_dead == true
		area.get_parent().queue_free()
		EnemyDirector.destroy_enemy(self, false)

func stop_movement():
	do_movement = false
