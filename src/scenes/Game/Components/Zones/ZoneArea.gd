class_name ZoneArea extends Area2D

@export var zone: Types.Zone

var _waterPlayerEntered: bool = false
var _firePlayerEntered: bool = false


func _on_area_entered(area: Area2D) -> void:
	if area.get_groups().has("Player"):
		var character := area as Character
		if character.element == Types.Element.Water:
			_waterPlayerEntered = true
		if character.element == Types.Element.Fire:
			_firePlayerEntered = true
		if _waterPlayerEntered and _firePlayerEntered:
			SignalBus.playerEnteredZone.emit(zone)

func _on_area_exited(area: Area2D) -> void:
	if area.get_groups().has("Player"):
		var character := area as Character
		if character.element == Types.Element.Water:
			_waterPlayerEntered = false
		if character.element == Types.Element.Fire:
			_firePlayerEntered = false
