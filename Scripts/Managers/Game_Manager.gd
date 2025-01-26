extends Node2D

class_name GameManager

enum STATE {MENU = -1, PLAY = 0, GAME_OVER = 1}
static var game_state

signal game_over

var xp_shard = preload("res://Scenes/xp_shard.tscn")
var player_scene = preload("res://Scenes/player.tscn")
var level_up_text = preload("res://Scenes/LevelUpText.tscn")

static var playerRef
var HUDRef

static var center

static var score

static var time_start
static var time_now

func _ready() -> void:
	game_state = STATE.MENU
	
	SignalManager.on_main_menu_entry.emit()
	
	playerRef = player_scene.instantiate()
	add_child(playerRef)
	center = get_viewport_rect().get_center()
	playerRef.global_position = center
	playerRef.visible = false
	playerRef.do_movement = false
	
	EnemyDirector.do_spawn = false

	HUDRef = get_node("HUD")
	
	score = 0
	time_start = Time.get_ticks_msec()
	SignalManager.update_score.emit(score)
	SignalManager.game_reset.connect(clear_xp)
	SignalManager.on_main_menu_entry.emit()
	SignalManager.spawn_xp_shards.connect(spawn_xp)
	SignalManager.level_up.connect(level_up)

func _process(delta: float) -> void:
	if (game_state == STATE.PLAY):
		time_now = Time.get_ticks_msec()
		var elapsed = time_now - time_start

static func get_game_state() -> STATE:
	return game_state

static func get_player_position() -> Vector2:
	return playerRef.global_position
	
static func start_game() -> void:
	game_state = STATE.PLAY
	playerRef.visible = true
	playerRef.do_movement = true
	EnemyDirector.do_spawn = false
	reset_game()
	SignalManager.on_game_start.emit()
	
static func end_game() -> void:
	SignalManager.play_sound.emit("game_over")
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

func level_up(newValue: int, playEffect: bool):
	if (playEffect == true):
		SignalManager.play_sound.emit("level_up")
		var lvlText = level_up_text.instantiate()
		add_child(lvlText)
		lvlText.global_position = get_player_position()
		lvlText.global_position.y -= 25

func spawn_xp(amount: int, position: Vector2):
	for i in amount:
		var xp = xp_shard.instantiate()
		var randPos = Vector2(randf_range(-10,10), randf_range(-10,10))
		xp.global_position = position + randPos
		get_tree().root.get_node("main/xp_group").call_deferred("add_child",xp)
	
func clear_xp():
	for entry in get_node("xp_group").get_children():
		entry.queue_free()
