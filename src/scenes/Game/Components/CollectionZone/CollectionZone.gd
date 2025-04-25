class_name CollectionZone extends Area2D

@export var zone : Types.Zone
@export var neededElement : Types.Element 
@export var limit : int = 999

@onready var _fireAltar: Sprite2D = %FireAltar
@onready var _waterAltar: Sprite2D = %WaterAltar
@onready var _animationPlayer : AnimationPlayer = %AnimationPlayer

var _isDisabled : bool = false
var _amount : int = 0:
	set(newValue):
		_amount = clamp(newValue, 0, limit)
		if _amount == limit:
			_disable()


func _ready() -> void:
	if neededElement == Types.Element.Water:
		_fireAltar.show()
		_waterAltar.hide()
		_animationPlayer.play("FIRE_IDLE")
	if neededElement == Types.Element.Fire:
		_waterAltar.show()
		_fireAltar.hide()
		_animationPlayer.play("WATER_IDLE")
	SignalBus.registerForMinimap.emit(self)

func _disable() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.PowerDown)
	_isDisabled = true
	if neededElement == Types.Element.Water:
		_animationPlayer.play("FIRE_DISABLED")
	if neededElement == Types.Element.Water:
		_animationPlayer.play("WATER_DISABLED")

func _on_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Cargo"):
		var cargo: Cargo = body as Cargo
		if cargo.getElement() == neededElement:
			if _isDisabled:
				return
			_amount += 1
			SignalBus.zoneGotCargo.emit(zone)
			cargo.destroy()
		else:
			cargo.uglyDestroy()
