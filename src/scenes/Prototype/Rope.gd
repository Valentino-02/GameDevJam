class_name Rope extends Line2D

@export var spring_length: float = 100.0
@export var spring_strength: float = 10000
@export var damping: float

@export var character: Character
@export var platform: RigidBody2D
@export var platform_attachement : Node2D

@export var max_force : float = 10000

func _ready() -> void:
	damping = calculate_critical_dampening()

func _physics_process(delta):
	var a_pos = character.global_position
	var b_pos = platform_attachement.global_position

	# Update line points
	points = [a_pos, b_pos]

	# Spring vector
	var diff = b_pos - a_pos
	var current_length = diff.length()
	var direction = diff.normalized()

	var displacement : float = current_length - spring_length
	if displacement < 0:
		return
	# Relative velocity
	var rel_velocity = character.linear_velocity - platform.linear_velocity
	var vel_along_spring = rel_velocity.dot(direction)

	# Hooke's law with damping
	var force : Vector2 = direction * ((spring_strength * displacement)  - (damping * vel_along_spring))
	force = force.limit_length(max_force)
	# Apply forces in opposite directions
	character.apply_force(force * 0.01)
	platform.apply_force(-force, platform_attachement.position)

func calculate_critical_dampening() -> float:
	return 2 * sqrt(spring_strength * platform.mass)
