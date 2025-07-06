extends Holdable
class_name Cup

@export var brew_next_scene: PackedScene
@export var water_added_next_scene: PackedScene
@export var milk_added_next_scene: PackedScene
@export var empty_version = preload("res://scenes/cup.tscn")

func brew_next() -> PackedScene:
	return brew_next_scene
	
func add_water() -> PackedScene:
	return water_added_next_scene
	
func add_milk() -> PackedScene:
	return milk_added_next_scene
	
func is_full() -> bool:
	return brew_next_scene == null && water_added_next_scene == null
	


func get_empty_version():
	return empty_version
