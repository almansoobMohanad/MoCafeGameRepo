extends StaticBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

var cups = ["Cup", "EspressoCup", "DoubleEspressoCup"]

var cup = null
var has_cup = false
var is_adding_water = false
#the type of item that is supposedly in the machine
var item_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	timer.timeout.connect(Callable(self, "_on_water_added"))


func _on_interact():
	
	if not has_cup and not is_adding_water:
	
		#First Item in inventory
		var inventory = player.get_inventory()
		
		#if there is something in inventory
		if inventory:
			
			cup = inventory[0]
			
			item_type = cup.item_type
			
			#if its on of the type of the cups specified in the cups list
			if item_type in cups:
				print('meow')
				
				player.remove_from_inventory(item_type)
				
				_add_water(item_type)
				
	#add to the player the cup
	elif has_cup and not is_adding_water:
		print("meow emroew")
		_create_cup(item_type)
		
	#interupting the machine	
	elif is_adding_water:
		print("please wait it is still adding water")
		
	else:
		print("need a cup i guess")
		
				
func _add_water(item_type):
	
	print("adding water to ", item_type, "...")
	has_cup = true
	is_adding_water = true
	timer.start(2)
	
	match item_type:
			
		"Cup":
			print("Cup")
			
		"EspressoCup":
			print("Esoresso")
			
		"DoubleEspressoCup":
			print("double espresoo")
			
		_:
			print("dunno whats that")
			
func _on_water_added():
	print("water added to the cup")
	timer.stop()
	is_adding_water = false
	
	
# a helper function to instantiate the cup to the player
func _create_cup(item_type):
	
	var cup_to_create = ""
	
	match item_type:
		
		"Cup":
			cup_to_create = "WaterCup"
		
		"EspressoCup":
			cup_to_create = "AmericanoCup"
			
		"DoubleEspressoCup":
			cup_to_create = "DoubleAmericanoCup"
			
		_:
			print("habibi whats that?")
			
	if player.add_to_inventory(cup_to_create):
		has_cup = false
		cup = null
		print(cup_to_create, " added to inventory")
	
	
