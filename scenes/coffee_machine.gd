extends StaticBody3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer3D

var is_brewing = false
var cup: Cup = null
var brewed_scene: PackedScene = null
var brewed_cup_ready: bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	timer.timeout.connect(Callable(self, "_on_brew_complete"))

func _on_interact():
	
	#If brewing just finished and cup is ready to be picked up
	if brewed_cup_ready:
		var brewed_cup: Node3D = brewed_scene.instantiate()
		get_tree().current_scene.add_child(brewed_cup)

		if player.add_to_inventory(brewed_cup):
			print("Picked up the cup")
		else:
			print("Inventory full. please drop something first")
			return

		# Reset state
		brewed_cup_ready = false
		brewed_scene = null
		return

	#Prevent new brew if one is waiting to be picked up
	if is_brewing or brewed_cup_ready:
		print("Machine is busy. Please wait or pick up your drink.")
		return

	#Start new brewing
	var held = player.get_inventory()
	if held != null and held is Cup:
		cup = held
		brewed_scene = cup.brew_next()

		if brewed_scene == null:
			print("This cup cannot be brewed further.")
			return

		is_brewing = true
		audio_player.play()
		timer.start(5.0)

		print("Brewing coffee:")
		player.remove_from_inventory()
		cup.queue_free()
	else:
		print("You need to hold a cup to brew coffee.")

func _on_brew_complete():
	is_brewing = false
	brewed_cup_ready = true
	print("Brewing complete. Interact again to collect your drink.")
