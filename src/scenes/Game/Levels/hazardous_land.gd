@tool
extends Area2D

@export var dangerType: Types.Element
@export var shape: Shape2D:	
	set(value):
		shape = value
		if Engine.is_editor_hint():
			get_child(0).shape = value
		update_configuration_warnings()

var _rect: Rect2:
	get: return shape.get_rect()

@onready var _fireParticle: GPUParticles2D = get_node("FireParticle")
@onready var _waterParticle: GPUParticles2D = get_node("WaterParticle")

var activeParticle: GPUParticles2D

func _ready() -> void:
	if Engine.is_editor_hint(): return
	SignalBus.cargoDroppedOnSurface.connect(_checkDiffuseHazard)
	activeParticle = _waterParticle if dangerType == Types.Element.Water else _fireParticle
	activeParticle.show()
	activeParticle.process_material.set("emission_box_extents", Vector2(_rect.size.x / 2, 1))
	activeParticle.emitting = true
	
func _checkDiffuseHazard(collisionPoint: Vector2, cargo: Cargo) -> void:
	if _rect.has_point(to_local(collisionPoint)):
		match cargo.element:
			Types.Element.Water:
				if dangerType == Types.Element.Water: return
				_diffuse(cargo)
			Types.Element.Fire:
				if dangerType == Types.Element.Fire: return
				_diffuse(cargo)
			_:
				return
				
func _diffuse(cargo: Cargo) -> void:
	cargo.destroy()
	SignalBus.hazardFixed.emit(cargo.element)
	queue_free()
	
func _get_configuration_warnings():
	if shape == null:
		return ["No area has been set for triggering!"]
	return []