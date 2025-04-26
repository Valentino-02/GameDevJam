class_name Rope extends Line2D

##The length that the string attempts to maintain (pixels)
@export var springLength: float = 150.0
##How hard the string pulls the platform towards the player
@export var platformSpringStrength: float = 5000
@export var maxForce : float = 10000
@export var character: Character
@export var platform: RigidBody2D
@export var platform_attachement : Node2D

@onready var _mask : Sprite2D = get_node("ParticleMask")
@onready var particles: CPUParticles2D = get_node("ParticleMask/GPUParticles2D")

func _ready() -> void:
	particles.emitting = true

func _physics_process(_delta):
	# Update line points
	points = [to_local(character.global_position), to_local(platform_attachement.global_position)]
	if get_tree().paused == false : _updateSpringForce(_delta)
	_updateRopeParticles()

func _updateSpringForce(delta : float):
	# Spring vector
	var diff = platform_attachement.global_position - character.global_position
	var currentLength = diff.length()
	var direction = diff.normalized()

	#String only pulls not pushes
	var displacement : float = currentLength - springLength
	if displacement < 0:
		if displacement < springLength * -0.15:
			platform.apply_force(Vector2.DOWN * 980 * 0.8 * delta, platform_attachement.global_position - platform.global_position)
		return

	var platform_vel = platform.linear_velocity.dot(-direction)

	#Spring force = kx (spring constant * displacement) - mv (mass * velocity)
	
	# Calculate for platform
	var kx : float = platformSpringStrength * displacement
	var mv : float = _calculateCriticalDampening(platform.mass, platformSpringStrength) * platform_vel
	var platform_force : Vector2 = -direction * (kx - mv)
	platform_force = platform_force.limit_length(maxForce * platform.mass)

	platform.apply_force(platform_force, platform_attachement.global_position - platform.global_position)

func _updateRopeParticles():
	_mask.position = self.points[0]
	_mask.rotation = self.points[0].direction_to(self.points[1]).angle()
	_mask.texture.size.x = self.points[0].distance_to(self.points[1])

func _calculateCriticalDampening(mass : float, spring_strength : float) -> float:
	return 2 * sqrt(spring_strength * mass)
