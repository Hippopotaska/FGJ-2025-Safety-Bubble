extends Node2D

class_name GameManager

var player_scene = preload("res://Scenes/player.tscn")

static var playerRef
var HUDRef

func _ready() -> void:
	playerRef = player_scene.instantiate()
	add_child(playerRef)
	playerRef.global_position = get_viewport_rect().get_center()

	HUDRef = get_node("HUD")

func _process(delta: float) -> void:
	pass

static func get_player_position() -> Vector2:
	return playerRef.global_position
	
static func end_game() -> void:
	
	pass
