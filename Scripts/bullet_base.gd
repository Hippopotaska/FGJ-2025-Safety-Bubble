extends Node2D

class_name Bullet

var init_completed = false

var speed = 350
var move_dir = Vector2.ZERO

func _ready() -> void:
	move_dir = Vector2.RIGHT.rotated(global_rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += move_dir.normalized() * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
