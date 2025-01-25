extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area = get_node("Area2D")
	area.area_entered.connect(_area_entered)

func _area_entered(area: Area2D) -> void:
	if (area.collision_layer == 1):
		area.get_parent().start_bubble_heal()
		queue_free()
