class_name CollectionZone extends Area2D

@export var zone : Types.Zone
@export var neededElement : Types.Element 
@export var limit : int = 999
@export var fireTextures: Array[Texture2D] = []
@export var waterTextures: Array[Texture2D] = []

@onready var altar: Sprite2D = $Altar
@onready var core: Sprite2D = $Altar/Core
@onready var _animationPlayer : AnimationPlayer = %AnimationPlayer

var _isDisabled : bool = false
var _amount : int = 0:
	set(newValue):
		_amount = clamp(newValue, 0, limit)
		if _amount == limit:
			_disable()


func _ready() -> void:
	if neededElement == Types.Element.Water:
		altar.texture = fireTextures[0]
		core.texture = fireTextures[1]
	if neededElement == Types.Element.Fire:
		altar.texture = waterTextures[0]
		core.texture = waterTextures[1]
	SignalBus.registerForMinimap.emit(self)

func _disable() -> void:
	AudioManager.sfx.play(ResourceIds.SfxId.PowerDown)
	_isDisabled = true
	_animationPlayer.play("DISABLED")

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
