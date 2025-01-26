extends Node2D

var do_fade = false
var start_color
var end_color
var time = 0

func _ready():
	start_color = modulate
	end_color = start_color
	end_color.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y -= 15 * delta
	if (do_fade):
		time += delta
		modulate = lerp(start_color, end_color, time)

func _on_timer_timeout() -> void:
	queue_free()

func _on_fade_timer_timeout() -> void:
	do_fade = true
