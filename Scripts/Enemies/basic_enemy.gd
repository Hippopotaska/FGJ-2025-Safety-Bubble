extends EnemyBase

class_name BasicEnemy

var spin_speed = 5

func _process(delta: float) -> void:
	if (do_movement):
		%Sprite2D.rotate(spin_speed * delta)
		move_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += move_direction * move_speed * delta
