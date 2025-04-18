class_name Character extends RigidBody2D

@export var orientationStrength : float = 1500

func _ready() -> void:
	var _particles: GPUParticles2D = $GPUParticles2D
	_particles.emitting = true
	
func _physics_process(_delta: float) -> void:
	apply_torque(_getOrientationTorque())

func _getOrientationTorque() -> float:
	return (0 - rotation) * orientationStrength
