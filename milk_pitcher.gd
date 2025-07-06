extends Holdable
class_name Milk_Pitcher

@onready var empty_version = preload("res://scenes/milk_pitcher.tscn")

func get_empty_version():
	return empty_version
