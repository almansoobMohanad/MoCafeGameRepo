extends StaticBody3D

@onready var interaction_area = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_player = $AudioStreamPlayer3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	
	var held_item = player.get_inventory()
	
	if held_item:
		
		#remove whatever cup and add empty cup
		if held_item is Holdable and held_item.has_content:
			player.remove_from_inventory()
			var empty_version = held_item.get_empty_version().instantiate()
			
			get_tree().current_scene.add_child(empty_version)
			empty_version.rotation = held_item.rotation
			player.add_to_inventory(empty_version)
			held_item.queue_free()
			audio_player.play()
		
		else:
			print("this item cannot be disposed")
			
	else:
		print("no item to throw")
		
		
