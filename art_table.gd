extends StaticBody3D

@onready var interaction_area = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

@onready var item_placed: Cup = null
var pending_milk = false  # prevent interaction until milk process is complete

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	timer.timeout.connect(Callable(self, "on_add_milk_complete"))

func _on_interact():
	if pending_milk:
		return  # Prevent spamming while milk is being added
	
	var held_item = player.get_inventory()
	
	if item_placed == null:
		if held_item is Cup:
			player.throw_item()
			held_item.position = self.position + Vector3(0, 0.1, 0)
			held_item.freeze = true
			held_item.get_node("InteractionArea").monitoring = false
			item_placed = held_item
			interaction_area.action_name = "draw art / pick up"
	
	elif item_placed != null and held_item == null:
		player.add_to_inventory(item_placed)
		item_placed = null
		interaction_area.action_name = "place cup"

	elif item_placed != null and held_item is Milk_Pitcher and held_item.has_content:
		timer.start(1.0)
		pending_milk = true  # block further interaction temporarily

func on_add_milk_complete():
	if not item_placed:
		pending_milk = false
		return
	
	var milk_drink_scene = item_placed.add_milk()  # should return a PackedScene
	if milk_drink_scene:
		var milk_drink = milk_drink_scene.instantiate()
		milk_drink.position = item_placed.position
		milk_drink.rotation = item_placed.rotation
		milk_drink.freeze = true
		item_placed.queue_free()
		get_parent().add_child(milk_drink)  # important: add to scene tree
		item_placed = milk_drink

	pending_milk = false
