extends Control

var shieldbar

func _ready() -> void:
	SignalManager.player_shieldhp_change.connect(update_shieldbar)
	SignalManager.player_xp_change.connect(update_xpbar)
	SignalManager.level_up.connect(update_lvl_text)
	SignalManager.game_over.connect(do_game_over_ui)
	SignalManager.update_score.connect(update_score)
	SignalManager.update_round_info.connect(update_round_info)
	
	change_gameover_panel_state(false)
	
	pass

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
	
func update_round_info(score: int, time: int):
	var mins = int(time / 60 / 1000)
	var secs = int(time / 1000) % 60
	%RoundTime.set_text(("%02d:" % mins) + ("%02d" %secs))
	%RoundScore.set_text(str(score))

func _on_reset_button_pressed() -> void:
	change_gameover_panel_state(false)
	GameManager.reset_game()

func _on_quit_button_button_down() -> void:
	get_tree().quit()
