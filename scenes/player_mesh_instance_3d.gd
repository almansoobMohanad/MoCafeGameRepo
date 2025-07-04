extends MeshInstance3D

@export var rotation_speed: float = 10.0  # Rotation smoothing factor
var movement_direction: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	# Rotate only if there's movement input
	if movement_direction != Vector3.ZERO:
		var target_rotation_y = atan2(movement_direction.x, movement_direction.z)
		var current_rotation_y = rotation.y
		rotation.y = lerp_angle(current_rotation_y, target_rotation_y, rotation_speed * delta)
