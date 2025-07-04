extends StaticBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer3D

var is_adding_water = false
var cup: Cup = null
var water_added_scene: PackedScene = null
var water_added_cup_ready: bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	timer.timeout.connect(Callable(self, "_on_brew_complete"))

func _on_interact():
	
	#If brewing just finished and cup is ready to be picked up
	if water_added_cup_ready:
		var brewed_cup: Node3D = water_added_scene.instantiate()
		get_tree().current_scene.add_child(brewed_cup)

		if player.add_to_inventory(brewed_cup):
			print("Picked up the cup")
		else:
			print("Inventory full. please drop something first")
			return

		# Reset state
		water_added_cup_ready = false
		water_added_scene = null
		return

	#Prevent new brew if one is waiting to be picked up
	if is_adding_water or water_added_cup_ready:
		print("Water Dispenser is busy. Please wait or pick up your drink.")
		return

	#Start new brewing
	var held = player.get_inventory()
	if held != null and held is Cup:
		cup = held
		water_added_scene = cup.add_water()

		if water_added_scene == null:
			print("You cannot add water further.")
			return

		is_adding_water = true
		#audio_player.play()
		timer.start(2.0)

		print("Adding Water")
		player.remove_from_inventory()
		cup.queue_free()
	else:
		print("You need to hold a cup to add water.")

func _on_brew_complete():
	is_adding_water = false
	water_added_cup_ready = true
	print("Adding water finished. Interact again to collect your drink.")
