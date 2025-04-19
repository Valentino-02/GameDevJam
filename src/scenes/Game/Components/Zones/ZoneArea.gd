class_name ZoneArea extends Area2D

@export var zone: Types.Zone

var _waterPlayerEntered: bool = false
var _firePlayerEntered: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Player"):
		var character := body as Character
		if character.element == Types.Element.Water:
			_waterPlayerEntered = true
		if character.element == Types.Element.Fire:
			_firePlayerEntered = true
		if _waterPlayerEntered and _firePlayerEntered:
			SignalBus.playerEnteredZone.emit(zone)

func _on_body_exited(body: Node2D) -> void:
	if body.get_groups().has("Player"):
		var character := body as Character
		if character.element == Types.Element.Water:
			_waterPlayerEntered = false
		if character.element == Types.Element.Fire:
			_firePlayerEntered = false
