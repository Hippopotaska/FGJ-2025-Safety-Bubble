extends EnemyBase

class_name BigEnemy

var spin_speed = 2.5
@export var hp = 3

func _process(delta: float) -> void:
	if (do_movement):
		%Sprite2D.rotate(spin_speed * delta)
		move_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += move_direction * move_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 16 && is_dead == false):
		area.get_parent().queue_free()
		
		hp -= 1
		if (hp > 0):
			return
		
		is_dead = true
		area.get_parent().queue_free()
		EnemyDirector.destroy_enemy(self, false)
