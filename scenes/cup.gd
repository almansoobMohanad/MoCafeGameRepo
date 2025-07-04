extends RigidBody3D

@export var item_type: String = "Cup"
@onready  var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.monitoring = false


func _on_interact():
	print("Interacted with", item_type)
	if player.add_to_inventory(item_type):  # Use `item_type` to identify the item
		queue_free()
