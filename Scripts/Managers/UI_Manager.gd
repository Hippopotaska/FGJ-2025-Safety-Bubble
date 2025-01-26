extends Control

class_name UIManager

var shieldbar

func _ready() -> void:
	SignalManager.player_shieldhp_change.connect(update_shieldbar)
	SignalManager.player_xp_change.connect(update_xpbar)
	SignalManager.level_up.connect(update_lvl_text)
	SignalManager.game_over.connect(do_game_over_ui)
	SignalManager.update_score.connect(update_score)
	SignalManager.update_round_info.connect(update_round_info)
	
	SignalManager.on_main_menu_entry.connect(setup_main_menu)
	SignalManager.on_game_start.connect(setup_game_start)
	
	change_gameover_panel_state(false)
	change_player_hud_state(false)
	
	pass


func setup_main_menu():
	%"Main Menu".visible = true
	%PlayerInfo.visible = false
	%"Game Over Panel".visible = false

func setup_game_start():
	%"Main Menu".visible = false
	%PlayerInfo.visible = true
	%"Game Over Panel".visible = false

func update_shieldbar(newValue: float) -> void:
	%BubbleShieldHPBar.value = newValue
	%ShieldHp.set_text(str(newValue).pad_decimals(0))
	
func update_xpbar(newValue: float) -> void:
	%XPBar.value = newValue

func update_lvl_text(newValue: int):
	%Lvl.set_text("LVL " + str(newValue))

func update_score(newValue: int):
	%Score.set_text("[center]%s[/center]" % newValue)

func do_game_over_ui():
	change_gameover_panel_state(true)

func change_gameover_panel_state(newState: bool):
	%"Game Over Panel".visible = newState
func change_main_menu_panel_state(newState: bool):
	%"Main Menu".visible = newState
func change_player_hud_state(newState: bool):
	%PlayerInfo.visible = newState

func update_round_info(score: int, time: int):
	var mins = int(time / 60 / 1000)
	var secs = int(time / 1000) % 60
	%RoundTime.set_text(("%02d:" % mins) + ("%02d" %secs))
	%RoundScore.set_text(str(score))

func _on_reset_button_pressed() -> void:
	SignalManager.play_sound.emit("ui_select")
	change_gameover_panel_state(false)
	GameManager.reset_game()

func _on_start_main_menu_pressed() -> void:
	SignalManager.play_sound.emit("ui_select")
	GameManager.start_game()


func _on_quit_button_button_down() -> void:
	SignalManager.play_sound.emit("ui_select")
	get_tree().quit()

func _on_quit_main_menu_pressed() -> void:
	SignalManager.play_sound.emit("ui_select")
	get_tree().quit()
