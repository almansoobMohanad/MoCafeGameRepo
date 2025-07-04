extends StaticBody3D

@export var cup_scene: PackedScene  # Set in the inspector

@onready var interaction_area: Area3D = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	if player.held_item != null:
		print("Player already holding something.")
		return

	var new_cup = cup_scene.instantiate()
	get_tree().current_scene.add_child(new_cup)  # Ensure it's in the scene tree
	var success = player.add_to_inventory(new_cup)

	if success:
		print("Player picked up a new cup.")
	else:
		print("Failed to add cup to inventory.")
