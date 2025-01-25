extends Node2D

var initial_speed = 80
var increase = 10

var go_to_player = false
var do_blinking = false

var base_color
var blink_color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_color = %Sprite2D.modulate
	blink_color = base_color
	blink_color.a = 0

func _physics_process(delta: float) -> void:
	%Sprite2D.scale.x = sin(Time.get_ticks_msec() * delta * 0.35)
	if (go_to_player):
		var direction = (GameManager.get_player_position() - global_position).normalized()
		global_position += direction * initial_speed * delta
		initial_speed += increase
	if (do_blinking):
		%Sprite2D.modulate = lerp(base_color, blink_color, sin(Time.get_ticks_msec() * delta * 0.65))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 64):
		go_to_player = true


func _on_blinking_timer_timeout() -> void:
	do_blinking = true

func _on_disappear_timer_timeout() -> void:
	queue_free()
