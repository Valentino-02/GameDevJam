class_name Character extends RigidBody2D

@export var left : bool = true

@export var rope_length : float = 5
@export var rope_spring_constant : bool = false ##Todo: implement rope physics, let it stretch and stuff

@export var platform : RigidBody2D
@export var rope_platform_attachement : Node2D


@export var strength: float = 200.0
@export var max_speed: float = 5.0

func _physics_process(delta: float) -> void:
	
	var force = get_input_vector() * strength
	apply_force(force)
	#Needed so that the characters stay upright
	apply_torque(get_orientation_torque())

@export var orientation_strength : float = 1.0
##TODO get the delta and make this spring like perhaps?
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
