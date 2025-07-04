extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 4.5
const MAX_INVENTORY_SIZE = 1
var inventory = []  # Stores items (max size 2)

var last_direction = Vector3.FORWARD
@export var rotation_speed = 4

var cup_scene = preload("res://scenes/cup.tscn")
var espressso_cup_scene = preload("res://scenes/espresso_cup.tscn")
var double_espressso_cup_scene = preload("res://scenes/double_espresso_cup.tscn")
var water_cup_scene = preload("res://scenes/water_cup.tscn")
var americano_cup_scene = preload("res://scenes/americano_cup.tscn")
var double_americano_cup_scene = preload("res://scenes/double_americano_cup.tscn")
var long_black_cup_scene = preload("res://scenes/long_black_cup.tscn")
var double_long_black_cup_scene = preload("res://scenes/double_long_black_cup.tscn")

var cups = ["Cup", "EspressoCup", "DoubleEspressoCup",
			"WaterCup", "AmericanoCup", "DoubleAmericanoCup", 
			"LongBlackCup", "DoubleLongBlackCup"]


func add_to_inventory(item_name: String) -> bool:
	if inventory.size() >= MAX_INVENTORY_SIZE:
		print("Inventory is full!")
		return false
	
	var new_item = null
	
	match item_name:
		"Cup":
			new_item = cup_scene.instantiate()
		"EspressoCup":
			new_item = espressso_cup_scene.instantiate()
		"DoubleEspressoCup":
			new_item = double_espressso_cup_scene.instantiate()
		"AmericanoCup":
			new_item = americano_cup_scene.instantiate()
		"WaterCup":
			new_item = water_cup_scene.instantiate()
		"DoubleAmericanoCup":
			new_item = double_americano_cup_scene.instantiate()
		"LongBlackCup":
			new_item = long_black_cup_scene.instantiate()
		"DoubleLongBlackCup":
			new_item = double_long_black_cup_scene.instantiate()
		_:
			print("Unknow item type: ", item_name)
			return false
		
	$Body/HandSocket.add_child(new_item)
	inventory.append(new_item)
	print("Added ", item_name, " to inventory")
	return true

# Removes an item from the inventory
func remove_from_inventory(item_type: String):
	
	for i in range(inventory.size()):

		if inventory[i].name == item_type:
			print("removed la")
			var removed_item = inventory[i]
			inventory.remove_at(i)  # Remove the item from the inventory
			$Body/HandSocket.get_child(1).free()
			return removed_item  # Return the removed item

	print("No ", item_type, " found in inventory!")
	
	return null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("Throw"):
		throw_item()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		last_direction = direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	$Body.rotation.y = lerp_angle($Body.rotation.y, atan2(-last_direction.x, -last_direction.z), delta * rotation_speed)

	move_and_slide()
	
func get_inventory():
	
	if inventory.size() > 0:
		return inventory
	
	return null
	
func throw_item():
	if inventory.size() == 0:
		print("No item to throw!")
		return
	
	var item = inventory.pop_front()
	$Body/HandSocket.remove_child(item)
	get_parent().add_child(item)
	
	#Update item's position and make it interactable again
	item.global_transform.origin = $Body/HandSocket.global_transform.origin
	
	if item.has_node("InteractionArea"):
		item.get_node("InteractionArea").monitoring = true
		
	if item is RigidBody3D:
		item.freeze = false
