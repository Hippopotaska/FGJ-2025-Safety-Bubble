extends Node2D

var move_direction
var move_speed = 80

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%Sprite2D.rotate(5 * delta)
	move_direction = (GameManager.get_player_position() - global_position).normalized()
	global_position += move_direction * move_speed * delta
