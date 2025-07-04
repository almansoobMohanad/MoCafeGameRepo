extends Camera3D

@onready var player = get_tree().get_first_node_in_group("player")  # Finds the first node in the "player" group

@export var follow_offset: Vector3 = Vector3(0, 52, 62.5)

func _process(delta: float) -> void:
	if player:
		# Directly use the player's global_transform
		global_transform.origin = player.global_transform.origin + follow_offset
