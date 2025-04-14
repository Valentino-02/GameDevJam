class_name Rope extends Line2D

@export var spring_length: float = 10.0
@export var spring_strength: float = 3
#@export var damping: float = 1.0

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

	var displacement = current_length - spring_length

	# Relative velocity
	#var rel_velocity = b.linear_velocity - a.linear_velocity
	#var vel_along_spring = rel_velocity.dot(direction)

	# Hooke's law with damping
	var force = direction * (spring_strength * displacement) # - damping * vel_along_spring)

	# Apply forces in opposite directions
	character.apply_force(force * 0.1)
	platform.apply_force(-force, platform_attachement.position)
