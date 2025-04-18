extends Area2D

@export var dangerType: Types.Element

@onready var _rect: Rect2 = get_child(0).shape.get_rect()
@onready var _fireParticle: GPUParticles2D = get_node("FireParticle")
@onready var _waterParticle: GPUParticles2D = get_node("WaterParticle")

var activeParticle: GPUParticles2D

func _ready() -> void:
	SignalBus.cargoDroppedOnSurface.connect(_checkDiffuseHazard)
	activeParticle = _waterParticle if dangerType == Types.Element.Water else _fireParticle
	activeParticle.show()
	print(_rect.size.x)
	activeParticle.process_material.set("emission_box_extents", Vector2(_rect.size.x/2,1))
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
				
func _diffuse(cargo:Cargo) -> void:
	cargo.destroy()
	SignalBus.hazardFixed.emit(cargo.element)
	queue_free()