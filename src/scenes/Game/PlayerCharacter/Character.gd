class_name Character extends RigidBody2D

@export var orientationStrength : float = 5000
@export var maxFlySpeed : float = 1000
@export var minFlySpeed : float = 250
@export var flyingAcceleration : float = 400
##How much the player can stretch the rope before inputs get ignored
@export var _leashLength : float = 1.2
##'L' or 'R' so we can detect inputs
@export var _suffix : String = "L"
@export var _rope: Rope 


var linearVelocity : Vector2 = Vector2.ZERO

func _getOrientationTorque() -> float:
	return (0 - rotation) * orientationStrength 


#Give instant vel
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var difference : Vector2 = global_position - _rope.platform_attachement.global_position
	var direction : Vector2 = difference.normalized()

	#accelerate in the input direction
	var input_dir : Vector2 = _getInputVector()
	var speed : float = linear_velocity.dot(input_dir) + (get_physics_process_delta_time() * flyingAcceleration)
	#calculate the velocity
	var velocity : Vector2 
	#if we are going down enable gravity
	var grav_mag : = input_dir.dot(Vector2.DOWN)
	if grav_mag >= 0.8:
		velocity = input_dir * speed
		velocity += Vector2.DOWN * (get_physics_process_delta_time() * ProjectSettings.get_setting("physics/2d/default_gravity") * grav_mag)
	else:#clamps the resulting speed
		speed = clampf(speed ,minFlySpeed, maxFlySpeed )
		velocity = input_dir * speed
	#check if we are leaving the rope's range, if so remove the component that is doing so
	if difference.length() > _rope.springLength * _leashLength:
		velocity -= getComponentAlongDirection(velocity, direction)
	#Check if we are under user input, if so, overwrite the velocity to the input velocity
	if velocity.length_squared() > 1.0:
		state.linear_velocity = velocity

	apply_torque(_getOrientationTorque())

func _getInputVector() -> Vector2:
	var input_vector : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("Right " + _suffix):
		input_vector.x += 1
	if Input.is_action_pressed("Left " + _suffix):
		input_vector.x -= 1
	if Input.is_action_pressed("Down " + _suffix):
		input_vector.y += 1
	if Input.is_action_pressed("Up " + _suffix):
		input_vector.y -= 1
	
	return input_vector.normalized()



static func getComponentAlongDirection(force: Vector2, direction : Vector2) -> Vector2:
	return (max(force.dot(direction), 0) * direction)
