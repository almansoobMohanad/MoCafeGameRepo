extends StaticBody3D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

	
func _on_interact():
	if player.add_to_inventory("Cup"):
		
		
		
		

		#new_cup.translation = Vector3(0, 0, 0)  # Position it properly
		print("interacted with Cup Storage and Picked Up a cup")
		
	else:
		print("Could not pick up, inventory is full")
	
