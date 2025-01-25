extends Node2D

signal shieldhp_change(new_value)

var start_hp = 100
var cur_hp

var max_hp = 200
var min_hp = 50

var start_scale

const BASE_HEAL = 1
var heal_mult = 0.5
const BASE_DAMAGE = 1
var damage_mult = 0.5

enum bubble_state {STABLE = 0, SHRINKING = 1, GROWING = 2}
var bubble_current_state

var heal_stacks = 0
var damage_stacks = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble_current_state = bubble_state.STABLE
	cur_hp = start_hp
	start_scale = scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (bubble_current_state == bubble_state.STABLE):
		return
	if (bubble_current_state == bubble_state.SHRINKING and cur_hp > min_hp):
		cur_hp -= (BASE_DAMAGE * damage_mult)
		if (cur_hp <= min_hp):
			cur_hp = min_hp
	if (bubble_current_state == bubble_state.GROWING and cur_hp < max_hp):
		cur_hp += (BASE_HEAL * heal_mult)
		if (cur_hp >= max_hp):
			cur_hp = max_hp
	
	scale = start_scale * (cur_hp * 0.01)

	SignalManager.player_shieldhp_change.emit((cur_hp / max_hp) * 100)
	pass
	
func start_growing() -> void:
	if (bubble_current_state != bubble_state.GROWING):
		bubble_current_state = bubble_state.GROWING
func start_shrinking() -> void:
	if (bubble_current_state != bubble_state.SHRINKING):
		bubble_current_state = bubble_state.SHRINKING

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 8 or area.collision_layer == 32):
		start_shrinking()
		EnemyDirector.destroy_enemy(area.get_parent())
