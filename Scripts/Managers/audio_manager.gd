extends Node

class_name AudioManager

static var bubble_pop_sfx = preload("res://Assets/SFX/Bubble_pop.ogg")
static var game_over_sfx = preload("res://Assets/SFX/GameOver.ogg")
static var level_up_sfx = preload("res://Assets/SFX/LevelUp.ogg")
static var pickup_xp_sfx = preload("res://Assets/SFX/Pickup_Xp.ogg")
static var shoot_sfx = preload("res://Assets/SFX/Shoot.ogg")
static var ui_select_sfx = preload("res://Assets/SFX/UI_Select.ogg")
static var enemy_hit = preload("res://Assets/SFX/enemy_hit.wav")

func _ready():
	SignalManager.play_sound.connect(PlaySound)
	%AudioStreamPlayer2D.max_polyphony = 128

func PlaySound(sfx_name: String):
	var randPitch = randf_range(-0.1, 0.1)
	match sfx_name:
		"bubble_pop":
			%Bubble_pop.stream =  bubble_pop_sfx
			%Bubble_pop.pitch_scale = 1 + randPitch
			%Bubble_pop.play()
		"game_over":
			%Game_over.stream =  game_over_sfx
			%Game_over.pitch_scale = 1 + randPitch
			%Game_over.play()
		"level_up":
			%level_up.stream =  level_up_sfx
			%level_up.pitch_scale = 1 + randPitch
			%level_up.play()
		"pickup_xp":
			%pickup_xp.stream =  pickup_xp_sfx
			%pickup_xp.pitch_scale = 1 + randPitch
			%pickup_xp.play()
		"shoot":
			%shoot.stream =  shoot_sfx
			%shoot.pitch_scale = 1 + randPitch
			%shoot.play()
		"ui_select":
			%ui_select.stream =  ui_select_sfx
			%ui_select.pitch_scale = 1 + randPitch
			%ui_select.play()
		"enemy_hit":
			%enemy_hit.stream =  enemy_hit
			%enemy_hit.pitch_scale = 1 + randPitch
			%enemy_hit.play()
		_:
			return
