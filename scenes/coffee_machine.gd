extends StaticBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer3D
var is_brewing = false
var has_cup = false  # Will hold the cup during brewing
var cup = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	timer.timeout.connect(Callable(self, "_on_brew_complete"))

# Interact with the coffee machine
func _on_interact():
	
	#if there is no cup in the machine
	if not has_cup:
		
		var inventory = player.get_inventory()
		
		print("INVENTORY ", inventory)
		
		if inventory:
			
			cup = player.get_inventory()[0].name
		
		#if a cup in player inventory exists
		if cup:
			
			print("checking what cup is this", cup)

			if cup == "Cup":
				print("Cup found")
				has_cup = true
				start_brewing()
			
			elif cup == "EspressoCup":
				print("Cup found")
				has_cup = true
				start_brewing()
				
			elif cup == "WaterCup":
				print("Cup found")
				has_cup = true
				start_brewing()
				
			elif cup == "LongBlackCup":
				print("Cup found")
				has_cup = true
				start_brewing()
				
			else:
				print("I think we going here")

		#cup does not exist in inventory
		else:
			
			print("You need a cup to start brewing")
			
	# If the machine has finished making the coffee and you interact
	elif has_cup and not is_brewing:
		
		
		var cup_to_add = ""
		
		if cup == "Cup":
			cup_to_add = "EspressoCup"
			#player.add_to_inventory("EspressoCup")
			
		elif cup == "EspressoCup":
			cup_to_add = "DoubleEspressoCup"
			#player.add_to_inventory("DoubleEspressoCup")
			
		elif cup == "WaterCup":
			cup_to_add = "LongBlackCup"
			
		elif cup == "LongBlackCup":
			cup_to_add = "DoubleLongBlackCup"
			
		if player.add_to_inventory(cup_to_add):
			has_cup = false
			print("Coffee Taken from Espresoo Machine")
			cup = null
		
		else:
			print("Inventory is Full, free your inventory to pick up the coffee")
			
	#If you interact with the machine during the brewing
	elif has_cup and is_brewing:
		print("Coffee Machine is still brewing, please wait.")


# Start brewing the coffee (5 seconds)
func start_brewing():
	if not is_brewing:
		is_brewing = true
		audio_player.play()
		print("Brewing espresso...")
		if cup == "Cup":
			player.remove_from_inventory("Cup")
		elif cup == "EspressoCup":
			player.remove_from_inventory("EspressoCup")
		elif cup == "WaterCup":
			player.remove_from_inventory("WaterCup")
		elif cup == "LongBlackCup":
			player.remove_from_inventory("LongBlackCup")
			
		print("inventoy after brewing", player.get_inventory())
		timer.start(5)  # Start a timer for 5 seconds
		

# Called when the brewing is complete
func _on_brew_complete():
	is_brewing = false
	print("Brewing complete! Espresso is ready to be added to the cup.")
	#cup = null
	
	if has_cup:
		# Add the espresso to the cup
		#has_cup = false
		print("Espresso added to the cup.")
		#cup = null
