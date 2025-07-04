extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 4.5

var last_direction = Vector3.FORWARD
@export var rotation_speed = 4

var held_item: Node3D = null

@onready var hand_socket: Node3D = $Body/HandSocket


func add_to_inventory(item: Node3D) -> bool:
	if held_item != null:
		return false  # Already holding something

	# Save item reference
	held_item = item

	# Reparent to hand socket
	if item.get_parent() != null:
		item.get_parent().remove_child(item)
	hand_socket.add_child(item)

	# Set its transform so it sits at hand socket's origin
	item.transform = Transform3D.IDENTITY

	# Disable physics and interaction while holding
	if item is RigidBody3D:
		item.freeze = true
	
	if item.has_node("InteractionArea"):
		item.get_node("InteractionArea").monitoring = false

	return true

func remove_from_inventory():
	if held_item == null:
		return

	# Re-enable physics before removing
	if held_item is RigidBody3D:
		held_item.freeze = false

	held_item = null



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
	return held_item



func throw_item():
	if held_item == null:
		print("No item to throw!")
		return
	
	$Body/HandSocket.remove_child(held_item)
	get_parent().add_child(held_item)
	
	#Update item's position and make it interactable again
	held_item.global_transform.origin = $Body/HandSocket.global_transform.origin
	
	if held_item.has_node("InteractionArea"):
		held_item.get_node("InteractionArea").monitoring = true
		
	if held_item is RigidBody3D:
		held_item.freeze = false
		
	held_item = null
