extends Node

class_name AudioManager

static var bubble_pop_sfx = preload("res://Assets/SFX/Bubble_pop.ogg")
static var game_over_sfx = preload("res://Assets/SFX/GameOver.ogg")
static var level_up_sfx = preload("res://Assets/SFX/LevelUp.ogg")
static var pickup_xp_sfx = preload("res://Assets/SFX/Pickup_Xp.ogg")
static var shoot_sfx = preload("res://Assets/SFX/Shoot.ogg")
static var ui_select_sfx = preload("res://Assets/SFX/UI_Select.ogg")

func _ready():
	SignalManager.play_sound.connect(PlaySound)
	%AudioStreamPlayer2D.max_polyphony = 128

func PlaySound(sfx_name: String):
	var stream
	match sfx_name:
		"bubble_pop":
			stream = bubble_pop_sfx
		"game_over":
			stream = game_over_sfx
		"level_up":
			stream = level_up_sfx
		"pickup_xp":
			stream = pickup_xp_sfx
		"shoot":
			stream = shoot_sfx
		"ui_select":
			stream = ui_select_sfx
		_:
			return
			
	var randPitch = randf_range(-0.1, 0.1)
	
	%AudioStreamPlayer2D.stream = stream
	%AudioStreamPlayer2D.pitch_scale = 1 + randPitch
	%AudioStreamPlayer2D.play()
