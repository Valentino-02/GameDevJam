class_name Rope extends Line2D

##The length that the string attempts to maintain (pixels)
@export var spring_length: float = 150.0
##How hard the string pulls the platform towards the player
@export var platform_spring_strength: float = 5000
##Player Spring Strength
@export var player_spring_strength : float = 600
##How much of the platform's gravity is transfered to the player
@export var player_gravity_coefficient : float = 0.1
##This is to prevent the platform overshooting due to the iterative nature of game physics. An unintended (beneficial?) consequence is that it acts as a weight limit
@export var max_force : float = 10000

@export var character: Character
@export var platform: RigidBody2D
@export var platform_attachement : Node2D




func _physics_process(delta):
	var a_pos = character.global_position
	var b_pos = platform_attachement.global_position

	# Update line points
	points = [a_pos, b_pos]

	# Spring vector
	var diff = b_pos - a_pos
	var current_length = diff.length()
	var direction = diff.normalized()

	#String only pulls not pushes
	var displacement : float = current_length - spring_length
	if displacement < 0:
		return

	# Relative velocity
	var player_vel = character.linear_velocity.dot(direction)
	var platform_vel = platform.linear_velocity.dot(-direction)

	#Spring force = kx (spring constant * displacement) - mv (mass * velocity)
	
	# Calculate for platform
	var kx : float = platform_spring_strength * displacement
	var mv : float = calculate_critical_dampening(platform.mass, platform_spring_strength) * platform_vel
	var platform_force : Vector2 = -direction * (kx - mv)
	platform_force = platform_force.limit_length(max_force * platform.mass)
	
	kx = player_spring_strength * displacement
	mv  = calculate_critical_dampening(character.mass, player_spring_strength) * player_vel
	var player_force : Vector2 = direction * (kx)# - mv)
	player_force = player_force.limit_length(max_force * character.mass)
	#Reduce gravity only if we are close
	if displacement < spring_length * max_stretch_percent:
		player_force += (-1 + player_gravity_coefficient) * CameraController.get_component_along_direction(player_force, direction)

	
	character.apply_force(player_force)
	platform.apply_force(platform_force, platform_attachement.position)

@export var max_stretch_percent : float = 0.1

func calculate_critical_dampening(mass : float, spring_strength : float) -> float:
	return 2 * sqrt(spring_strength * mass)
