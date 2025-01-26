extends EnemyBase

class_name BigEnemy

var spin_speed = 2.5
var hp = 3

func _ready() -> void:
	move_speed = 60
	score_gain = 150
	xp_drops = 5

func _process(delta: float) -> void:
	if (do_movement):
		%Sprite2D.rotate(spin_speed * delta)
		move_direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += move_direction * move_speed * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 16):
		area.get_parent().queue_free()
		hp -= 1
		if (hp > 0):
			return
		
		for i in xp_drops:
			var xp = xp_shard.instantiate()
			var randPos = Vector2(randf_range(-25,25), randf_range(-25,25))
			xp.global_position = global_position + randPos
			get_tree().root.get_node("main/xp_group").call_deferred("add_child",xp)
			area.get_parent().queue_free()
			EnemyDirector.destroy_enemy(self)
