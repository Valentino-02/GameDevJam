class_name Rope extends Line2D

##The length that the string attempts to maintain (pixels)
@export var springLength: float = 150.0
##How hard the string pulls the platform towards the player
@export var platformSpringStrength: float = 5000
@export var maxForce : float = 10000
@export var maxStretchPercent : float = 0.1
@export var character: Character
@export var platform: RigidBody2D
@export var platform_attachement : Node2D

func _physics_process(_delta):
	var a_pos = character.global_position
	var b_pos = platform_attachement.global_position

	# Update line points
	points = [to_local(a_pos), to_local(b_pos)]

	# Spring vector
	var diff = b_pos - a_pos
	var currentLength = diff.length()
	var direction = diff.normalized()

	#String only pulls not pushes
	var displacement : float = currentLength - springLength
	if displacement < 0:
		return

	# Relative velocity
	#var _player_vel = character.linear_velocity.dot(direction)
	var platform_vel = platform.linear_velocity.dot(-direction)

	#Spring force = kx (spring constant * displacement) - mv (mass * velocity)
	
	# Calculate for platform
	var kx : float = platformSpringStrength * displacement
	var mv : float = _calculateCriticalDampening(platform.mass, platformSpringStrength) * platform_vel
	var platform_force : Vector2 = -direction * (kx - mv)
	platform_force = platform_force.limit_length(maxForce * platform.mass)
	# calculate for player
	#kx = playerSpringStrength * displacement
	#mv  = _calculateCriticalDampening(character.mass, playerSpringStrength) * player_vel
	#var player_force : Vector2 = direction * kx #- mv)
	#player_force = player_force.limit_length(maxForce * character.mass)
	#Reduce gravity only if we are close
	#if displacement < springLength * maxStretchPercent:
	#	player_force += (-1 + playerGravityCoefficient) * Character.getComponentAlongDirection(player_force, direction)
	
	#character.apply_force(player_force)
	platform.apply_force(platform_force, platform_attachement.global_position - platform.global_position)


func _calculateCriticalDampening(mass : float, spring_strength : float) -> float:
	return 2 * sqrt(spring_strength * mass)
