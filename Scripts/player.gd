extends Node2D

class_name Player

var bullet_scene = preload("res://Scenes/player_bullet.tscn")

signal xp_change(new_value)

var move_direction = Vector2(0,0)
var move_speed = 150
var diagonal_limiter = 0.7

var level = 1
var curXP = 0
var xpNeeded
var xpBase = 10

var gun_power = 1
var cur_gun_xp = 0
var gun_xp = 5
var spread = 20

var shoot_cooldown = 1.5
var can_shoot = true

var do_movement = true
var rect
var center
var min
var max

var bubble_shield

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble_shield = get_node("Bubble")
	SignalManager.player_xp_change.emit(curXP)
	xpNeeded = xpBase
	do_movement = true
	SignalManager.game_reset.connect(reset_player)
	
	rect = get_viewport_rect()
	center = rect.get_center()
	min = Vector2(center.x - (rect.size.x * 0.5), center.y - (rect.size.y *0.5))
	max = Vector2(center.x + (rect.size.x * 0.5), center.y + (rect.size.y *0.5))

func _physics_process(delta: float) -> void:
	if (do_movement):
		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
	
		bubble_shield.rotation_degrees = -rotation_degrees
	
		move_direction = Vector2.ZERO
		if (Input.is_action_pressed("MoveUp")):
			move_direction.y = -1
		if (Input.is_action_pressed("MoveDown")):
			move_direction.y = 1
		if (Input.is_action_pressed("MoveLeft")):
			move_direction.x = -1
		if (Input.is_action_pressed("MoveRight")):
			move_direction.x = 1
		if (can_shoot and Input.is_action_pressed("Shoot")):
			shoot()
	
		move_direction.normalized()
		global_position += move_direction.normalized() * move_speed * delta
		global_position = global_position.clamp(min, max)

func gain_xp(xpAmount: int) -> void:
	if (%Bubble.bubble_current_state == 4):
		cur_gun_xp += 1
		if (cur_gun_xp >= gun_xp):
			gun_power += 1
			cur_gun_xp = 0
			gun_xp += gun_xp * 2
	
	curXP += xpAmount
	if (curXP >= xpNeeded):
		SignalManager.player_xp_change.emit(((float)(curXP) / (float)(xpNeeded) * 100))
		level_up()
		xpNeeded = (int)(xpBase * pow(level, 1.5))
		curXP = 0
	SignalManager.player_xp_change.emit(((float)(curXP) / (float)(xpNeeded) * 100))

func level_up() -> void:
	level += 1
	shoot_cooldown *= 0.8
	SignalManager.level_up.emit(level, true)
	start_bubble_heal()
	GameManager.gain_score(100 * level)

func shoot() -> void:
	# Source for shooting logic: https://www.youtube.com/watch?v=oKF_DvARvWc
	for i in gun_power:
		SignalManager.play_sound.emit("shoot")
		var bullet = bullet_scene.instantiate()
		bullet.global_position = %Muzzle.global_position
		
		if gun_power == 1:
			bullet.rotation = global_rotation
		else:
			var arc_rad = deg_to_rad(spread)
			var increment = arc_rad / (gun_power - 1)
			bullet.global_rotation = (
				global_rotation +
				increment * i -
				arc_rad / 2
			)
		
		get_tree().root.add_child(bullet)
		can_shoot = false
	%shoot_cooldown.start(shoot_cooldown)

func start_bubble_heal() -> void:
	bubble_shield.start_growing()

func start_bubble_damage() -> void:
	bubble_shield.start_shrinking()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 8 or area.collision_layer == 32):
		GameManager.end_game()
		do_movement = false
	elif (area.collision_layer == 128):
		SignalManager.play_sound.emit("pickup_xp")
		gain_xp(2)
		area.get_parent().queue_free()

func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true

func reset_player():
	do_movement = true
	reset_xp()
	reset_gun_power()
	reset_shield()
	
	SignalManager.player_xp_change.emit(((float)(curXP) / (float)(xpNeeded) * 100))
	SignalManager.level_up.emit(level, false)

func reset_gun_power():
	gun_power = 1
	cur_gun_xp = 0
	gun_xp = 5
	
func reset_xp():
	level = 1
	curXP = 0
	xpBase = 10
	xpNeeded = xpBase
	
func reset_shield():
	bubble_shield.reset()
