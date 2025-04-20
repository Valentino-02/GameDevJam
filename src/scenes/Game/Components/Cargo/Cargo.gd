class_name Cargo extends RigidBody2D

@export var element: Types.Element = Types.Element.Fire

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: GPUParticles2D = %GPUParticles2D

var _element: Types.Element = Types.Element.Null
var _beingDestroyed : bool = false


func _ready() -> void:
	body_entered.connect(_bodyEntered)
	if _element == Types.Element.Null:
		_element = element
	_loadElementTextures()


func setElement(targetElement: Types.Element) -> void:
	_element = targetElement

func getElement() -> Types.Element:
	return _element

func destroy() -> void:
	var fleetingNumber = PreloadedResources.fleetingNumber.instantiate()
	fleetingNumber.position = position
	get_parent().add_child(fleetingNumber)
	_beingDestroyed = true
	var tween = _playDestructionAnimation()
	AudioManager.sfx.play(ResourceIds.SfxId.CargoCollect)
	await tween.finished
	queue_free()

func uglyDestroy() -> void:
	_beingDestroyed = true
	var tween = _playDestructionAnimation()
	AudioManager.sfx.play(ResourceIds.SfxId.CargoDiscard)
	await tween.finished
	queue_free()

func _playDestructionAnimation() -> Tween:
	var tween := create_tween()
	tween.set_parallel(true)
	var offset := Vector2(randf_range(-10, 10), randf_range(-30, -10))
	tween.tween_property(_particles, "modulate:a", 0.0, 0.6).set_ease(Tween.EASE_IN)
	tween.tween_property(_particles, "scale", Vector2.ZERO, 0.6).set_ease(Tween.EASE_IN)
	tween.tween_property(_sprite, "modulate:a", 0.0, 0.4).set_ease(Tween.EASE_IN)
	tween.tween_property(_sprite, "scale", Vector2.ZERO, 0.4).set_ease(Tween.EASE_IN)
	_particles.restart()
	return tween

func _loadElementTextures() -> void:
	if _element == Types.Element.Fire:
		_sprite.texture = PreloadedResources.fireCrateTexture
		_particles.texture = PreloadedResources.fireParticleTexture
	elif _element == Types.Element.Water:
		_sprite.texture = PreloadedResources.waterCrateTexture
		_particles.texture = PreloadedResources.waterParticleTexture

func _bodyEntered(node2d: Node2D) -> void:
	if node2d is TileMapLayer:
		SignalBus.cargoDroppedOnSurface.emit(global_position, self)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _beingDestroyed:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		uglyDestroy()
