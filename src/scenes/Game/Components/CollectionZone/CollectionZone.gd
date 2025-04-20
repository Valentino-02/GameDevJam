class_name CollectionZone extends Area2D

@export var zone : Types.Zone
@export var neededElement : Types.Element 


func _ready() -> void:
	if neededElement == Types.Element.Water:
		modulate = Color("d32600")
	if neededElement == Types.Element.Fire:
		modulate = Color("3c3bdc")

func _on_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Cargo"):
		var cargo: Cargo = body as Cargo
		if cargo.getElement() == neededElement:
			SignalBus.zoneGotCargo.emit(zone)
			cargo.destroy()
		else:
			cargo.uglyDestroy()
