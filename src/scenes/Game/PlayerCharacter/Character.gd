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

func _ready() -> void:
	var _particles: GPUParticles2D = $GPUParticles2D
	_particles.emitting = true
	


func _getOrientationTorque() -> float:
	return (0 - rotation) * orientationStrength 


#Give instant vel
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var difference : Vector2 = global_position - _rope.platform_attachement.global_position
	var direction : Vector2 = difference.normalized()
	var velocity : Vector2 
	var input_dir : Vector2 = _getInputVector()

	#accelerate the current speed
	var speed : float = linear_velocity.dot(input_dir) 
	var accel : float = get_physics_process_delta_time() * flyingAcceleration
	#if we are going down enable gravity
	var grav_mag : = input_dir.dot(Vector2.DOWN)
	if grav_mag >= 0.8: #if trying to fall
		#normal acceleration
		velocity = input_dir * (speed + accel)
		#gravity acceleration
		velocity += Vector2.DOWN * (get_physics_process_delta_time() * ProjectSettings.get_setting("physics/2d/default_gravity") * grav_mag)
	else: #any other powered movement that isn't down
		#accelerates within the bounds, or lets it go wild
		speed = max(speed, clampf(speed + accel, minFlySpeed, maxFlySpeed))
		speed = clampf(speed ,minFlySpeed, maxFlySpeed )
		velocity = input_dir * speed
	#check if we are leaving the rope's range, if so remove the component that is doing so
	var extra : float = (difference.length() - _rope.springLength)/_rope.springLength
	if extra > 0.0:
		var factor : float = clampf((1 - ((_leashLength - extra)/_leashLength)), 0, 1)
		velocity -= factor * getComponentAlongDirection(velocity, direction)
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
