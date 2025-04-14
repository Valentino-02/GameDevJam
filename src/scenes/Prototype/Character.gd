class_name Character extends RigidBody2D

@export var left : bool = true


@export var strength: float = 200.0
@export var max_speed: float = 5.0

func _physics_process(delta: float) -> void:
	
	var force = get_input_vector() * strength
	apply_force(force)
	apply_torque(get_orientation_torque())

@export var orientation_strength : float = 1.0
func get_orientation_torque() -> float:
	return (0 - rotation) * orientation_strength

func get_input_vector() -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO
	var suffix : String = "L" if left else "R"

	if Input.is_action_pressed("Right " + suffix):
		input_vector.x += 1
	if Input.is_action_pressed("Left " + suffix):
		input_vector.x -= 1
	if Input.is_action_pressed("Down " + suffix):
		input_vector.y += 1
	if Input.is_action_pressed("Up " + suffix):
		input_vector.y -= 1

	return input_vector.normalized()
