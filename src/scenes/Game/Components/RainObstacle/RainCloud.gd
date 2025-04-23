class_name RainCloud extends Node2D

##When a body is inside the rain this material is applied
@export var slippery_material : PhysicsMaterial

var _raining : bool = true

signal rainingChanged

@onready var _hitbox : Area2D = get_node("RainHitBox")
@onready var _particlePlayer : CPUParticles2D = get_node("ParticleMask/RainEmitterPlayer")
@onready var _raycast : RayCast2D = get_node("RayCast2D")
@onready var _mask : Sprite2D = get_node("ParticleMask")
@onready var _particleBack : CPUParticles2D = get_node("RainEmitterBehind")
@onready var _audioPlayer : AudioStreamPlayer2D = AudioManager.sfx.createPlayer2D(ResourceIds.SfxId.Raining)

func _ready() -> void:
	_particlePlayer.emitting = true
	_particleBack.emitting = true
	add_child(_audioPlayer)
	_audioPlayer.position = Vector2.DOWN * 100
	_setRaining(_raining)

func _setRaining(is_raining : bool = not _raining ):
	if is_raining:
		_particlePlayer.emitting = true
		_particleBack.emitting = true
		_audioPlayer.play(0.0)
		
		await get_tree().create_timer(0.3).timeout
		_hitbox.get_overlapping_bodies().all(_assignMaterial.bind(slippery_material))
		
	else:
		_particlePlayer.emitting = false
		_particleBack.emitting = false
		_audioPlayer.stop()
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
		
func _physics_process(delta: float) -> void:
	_scaleMask(delta)

func _scaleMask(delta : float):
	var dist : float
	if _raycast.is_colliding():
		dist = abs((to_local(_raycast.get_collision_point()) - _raycast.position).y)
	else:
		dist = abs((_raycast.target_position - _raycast.position).y)
	_mask.scale.y = lerp(_mask.scale.y, dist / 100.0, delta * 10)
	_mask.position.y = _mask.scale.y * 50.0
