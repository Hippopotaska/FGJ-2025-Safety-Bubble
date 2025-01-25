extends Control

var shieldbar

func _ready() -> void:
	SignalManager.player_shieldhp_change.connect(update_shieldbar)
	pass

func update_shieldbar(newValue: float) -> void:
	%BubbleShieldHPBar.value = newValue
	pass

func update_xpbar(newValue: float) -> void:
	%XPBar.value = newValue
	pass
