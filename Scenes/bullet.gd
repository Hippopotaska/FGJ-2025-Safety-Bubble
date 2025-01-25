extends Node2D

class_name Bullet

var init_completed = false

var speed = 200
var move_dir = Vector2.ZERO

func initialize(bullet_owner: int, direction: Vector2) -> void:
	if (bullet_owner == 1): # owner is player
		%Area2D.set_collision_layer_value(16, true)
		%Area2D.set_collision_mask_value(8, true)
		pass
	elif (bullet_owner == 2): # owner is enemy
		%Area2D.set_collision_layer_value(32, true)
		%Area2D.set_collision_mask_value(0, true)
		%Area2D.set_collision_mask_value(2, true)
		pass
	else:
		print_debug("Bullet was initialized wrong!")
	
	move_dir = direction.normalized()
	init_completed = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (init_completed == true):
		global_position += move_dir.normalized() * speed * delta


func _on_timer_timeout() -> void:
	queue_free()
