extends EnemyBase

class_name FastEnemy

func _process(delta: float) -> void:
	if (do_movement):
		look_at(GameManager.get_player_position())
		move_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += move_direction * move_speed * delta
