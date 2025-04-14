extends RigidBody2D

func _physics_process(delta: float) -> void:
	apply_torque(get_orientation_torque())

@export var orientation_strength : float = 500
func get_orientation_torque() -> float:
	return (0 - rotation) * orientation_strength
