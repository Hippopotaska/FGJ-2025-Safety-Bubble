extends Node2D

class_name Player

var bullet_scene = preload("res://Scenes/bullet.tscn")

signal xp_change(new_value)

var move_direction = Vector2(0,0)
var move_speed = 150
var diagonal_limiter = 0.7

var level = 1
var curXP = 0
var xpNeeded = 10

var bubble_shield

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble_shield = get_node("Bubble")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
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
	if (Input.is_action_pressed("Shoot")):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = %Muzzle.global_position
		get_tree().root.add_child(bullet)
		bullet.initialize(1, ((get_global_mouse_position() - %Muzzle.global_position).normalized()))
	
	move_direction.normalized()
	
	global_position += move_direction.normalized() * move_speed * delta
	pass

func start_bubble_heal() -> void:
	bubble_shield.start_growing()

func start_bubble_damage() -> void:
	bubble_shield.start_shrinking()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == 8 or area.collision_layer == 32):
		print_debug("You ded")
		GameManager.end_game()
