extends RigidBody3D
class_name Cup

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@export var brew_next_scene: PackedScene
@export var water_added_next_scene: PackedScene

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.monitoring = false
	freeze = false  # default state when on ground

func _on_interact():
	print("Interacted with cup instance:", self)

	if player.add_to_inventory(self):  # Add the actual object
		interaction_area.monitoring = false
		freeze = true  # Disable physics so it doesn't fall in the player's hand

func brew_next() -> PackedScene:
	return brew_next_scene
	
func add_water() -> PackedScene:
	return water_added_next_scene
