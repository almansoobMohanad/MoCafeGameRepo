extends RigidBody3D
class_name Holdable

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@export var has_content: bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.monitoring = true
	freeze = false
	
func _on_interact():
	print("Interacted with holdable item: ", self)
	
	if player.add_to_inventory(self):
		interaction_area.monitoring = false
		freeze = true
		
func is_full() -> bool:
	return has_content
	
func get_empty_version() -> PackedScene:
	return null  # Override this in specific classes

	
