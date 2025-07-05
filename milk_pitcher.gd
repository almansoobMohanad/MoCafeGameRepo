extends RigidBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.monitoring = true
	freeze = false  # default state when on ground

func _on_interact():
	print("Interacted with milk frother:", self)

	if player.add_to_inventory(self):  # Add the actual object
		interaction_area.monitoring = false
		freeze = true  # Disable physics so it doesn't fall in the player's hand
