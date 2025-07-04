extends StaticBody3D

@onready var interaction_area = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var audio_player = $AudioStreamPlayer3D

var cups = ["EspressoCup", "DoubleEspressoCup",
			"WaterCup", "AmericanoCup", "DoubleAmericanoCup", 
			"LongBlackCup", "DoubleLongBlackCup"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	
	var inventory = player.get_inventory()
	
	if inventory:
		
		var item = inventory[0].item_type
		
		print("this is the item")
		
		#remove whatever cup and add empty cup
		if item in cups:
			player.remove_from_inventory(item)
			player.add_to_inventory("Cup")
			audio_player.play()
		
		else:
			print("this item cannot be disposed")
			
	else:
		print("no item to throw")
		
		
