class_name Character extends RigidBody2D

@export var orientationStrength : float = 1500
@export var element : Types.Element


func _physics_process(_delta: float) -> void:
	apply_torque(_getOrientationTorque())

func _getOrientationTorque() -> float:
	return (0 - rotation) * orientationStrength
