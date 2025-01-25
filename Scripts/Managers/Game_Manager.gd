extends Node2D

class_name GameManager

enum STATE {PLAY = 0, GAME_OVER = 1}
static var game_state

signal game_over

var player_scene = preload("res://Scenes/player.tscn")

static var playerRef
var HUDRef

static var center

static var score

static var time_start
static var time_now

func _ready() -> void:
	game_state = STATE.PLAY
	playerRef = player_scene.instantiate()
	add_child(playerRef)
	center = get_viewport_rect().get_center()
	playerRef.global_position = center

	HUDRef = get_node("HUD")
	
	score = 0
	time_start = Time.get_ticks_msec()
	SignalManager.update_score.emit(score)

func _process(delta: float) -> void:
	if (game_state == STATE.PLAY):
		time_now = Time.get_ticks_msec()
		var elapsed = time_now - time_start

static func get_game_state() -> STATE:
	return game_state

static func get_player_position() -> Vector2:
	return playerRef.global_position
	
static func end_game() -> void:
	game_state = STATE.GAME_OVER
	SignalManager.game_over.emit()
	SignalManager.update_round_info.emit(score, int(time_now - time_start))
	pass
	
static func reset_game() -> void:
	playerRef.global_position = center
	game_state = STATE.PLAY
	SignalManager.game_reset.emit()
	score = 0
	time_start = Time.get_ticks_msec()
	SignalManager.update_score.emit(score)

static func gain_score(add_score: float):
	score += add_score
	SignalManager.update_score.emit(score)
