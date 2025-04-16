class_name Cargo extends RigidBody2D

@export var element: Types.Element = Types.Element.Fire

@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: GPUParticles2D = %GPUParticles2D

var _element: Types.Element = Types.Element.Null


func _ready() -> void:
	if _element == Types.Element.Null:
		_element = element
	if _element == Types.Element.Fire:
		_sprite.texture = PreloadedResources.fireCrateTexture
	elif _element == Types.Element.Water:
		_sprite.texture = PreloadedResources.waterCrateTexture


func setElement(targetElement: Types.Element) -> void:
	_element = targetElement

func getElement() -> Types.Element:
	return _element

func destroy() -> void:
	_sprite.visible = false
	_particles.restart()
	await _particles.finished
	queue_free()
