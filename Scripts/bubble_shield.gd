extends Node2D

signal shieldhp_change(new_value)

var start_hp = 100
var cur_hp

var max_hp = 200
var min_hp = 50

const BASE_HEAL = 1
var heal_mult = 0.25
const BASE_DAMAGE = 1
var damage_mult = 0.35

var start_scale

enum bubble_state {STABLE = 0, SHRINKING = 1, GROWING = 2, BROKEN = 3, FULL = 4}
static var bubble_current_state


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble_current_state = bubble_state.STABLE
	cur_hp = start_hp
	start_scale = scale
	SignalManager.player_shieldhp_change.emit(calculate_value_forui())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameManager.get_game_state() != 0):
		return
	if (bubble_current_state == bubble_state.STABLE 
	or bubble_current_state == bubble_state.BROKEN
	or bubble_current_state == bubble_state.FULL):
		return
	elif (bubble_current_state == bubble_state.SHRINKING and cur_hp > min_hp):
		cur_hp -= (BASE_DAMAGE * damage_mult)
		if (cur_hp <= min_hp):
			bubble_current_state = bubble_state.BROKEN
			cur_hp = min_hp
	elif (bubble_current_state == bubble_state.GROWING and cur_hp < max_hp):
		cur_hp += (BASE_HEAL * heal_mult)
		if (cur_hp >= max_hp):
			bubble_current_state = bubble_state.FULL
			cur_hp = max_hp
	
	scale = start_scale * (cur_hp * 0.01)
	var ui_value = (cur_hp / max_hp) * 100
	SignalManager.player_shieldhp_change.emit(calculate_value_forui())
	
func calculate_value_forui() -> float:
	return 	float(cur_hp) / float(max_hp) * float(100)

func start_growing() -> void:
	if (bubble_current_state != bubble_state.GROWING):
		bubble_current_state = bubble_state.GROWING
func start_shrinking() -> void:
	if (bubble_current_state != bubble_state.SHRINKING):
		SignalManager.play_sound.emit("bubble_pop")
		get_parent().reset_gun_power()
		bubble_current_state = bubble_state.SHRINKING

func reset():
	bubble_current_state = bubble_state.STABLE
	cur_hp = start_hp
	scale = start_scale * (cur_hp * 0.01)
	var value = (cur_hp / max_hp) * 100
	SignalManager.player_shieldhp_change.emit(calculate_value_forui())
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 8 or area.collision_layer == 32):
		start_shrinking()
		EnemyDirector.destroy_enemy(area.get_parent(), true)
