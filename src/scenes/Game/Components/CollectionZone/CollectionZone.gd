class_name CollectionZone extends Area2D

@export var zone : Types.Zone
@export var element : Types.Element 

func _on_body_entered(body: Node2D) -> void:
	if body.get_groups().has("Cargo"):
		var cargo: Cargo = body as Cargo
		if cargo.getElement() == element:
			SignalBus.zoneGotCargo.emit(zone)
		cargo.queue_free()
