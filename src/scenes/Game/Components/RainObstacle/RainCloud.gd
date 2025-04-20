class_name RainCloud extends Node2D

##When a body is inside the rain this material is applied
@export var slippery_material : PhysicsMaterial

var _raining : bool = true

signal rainingChanged

@onready var _hitbox : Area2D = get_node("RainHitBox")
@onready var _particlePlayer : GPUParticles2D = get_node("RainEmitterPlayer")
@onready var _particleBack : GPUParticles2D = get_node("RainEmitterBehind")


func _setRaining(is_raining : bool = not _raining ):
	if is_raining:
		_particlePlayer.emitting = true
		_particleBack.emitting = true
		await get_tree().create_timer(0.3).timeout
		_hitbox.get_overlapping_bodies().all(_assignMaterial.bind(slippery_material))
		
	else:
		_particlePlayer.emitting = false
		_particleBack.emitting = false
		await get_tree().create_timer(0.3).timeout
		_hitbox.get_overlapping_bodies().all(_assignMaterial.bind(null))
		
	_raining = is_raining
	rainingChanged.emit()

func _assignMaterial(body : RigidBody2D, mat):
	body.physics_material_override = mat

##Responds when an object leaves the rain
func _onRainLeft(body:Node2D) -> void:
	if body is RigidBody2D and _raining:
		body.physics_material_override = null

##Responds when an object enters the rain
func _onRainEntered(body:Node2D) -> void:
	if body is RigidBody2D and _raining:
		body.physics_material_override = slippery_material
		
