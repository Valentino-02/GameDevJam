class_name RainCloud extends Node2D

##When a body is inside the rain this material is applied
@export var slippery_material : PhysicsMaterial

@export var raining : bool = true:
	get: return raining
	set (x): _setRaining(x)


@onready var _hitbox : Area2D = get_node("RainHitBox")
@onready var _particle : CPUParticles2D = get_node("RainEmitter")


func _setRaining(is_raining : bool):
	if is_raining:
		_particle.emitting = true
		_hitbox.get_overlapping_bodies().all(_assignMaterial.bind(slippery_material))
	else:
		_particle.emitting = false
		_hitbox.get_overlapping_bodies().all(_assignMaterial.bind(null))
	raining = is_raining

func _assignMaterial(body : RigidBody2D, mat):
	body.physics_material_override = mat

##Responds when an object leaves the rain
func _onRainLeft(body:Node2D) -> void:
	if body is RigidBody2D and raining:
		body.physics_material_override = null

##Responds when an object enters the rain
func _onRainEntered(body:Node2D) -> void:
	if body is RigidBody2D and raining:
		body.physics_material_override = slippery_material

